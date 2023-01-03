using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Reflection;
using System.Windows.Forms;
using System.Windows.Forms.VisualStyles;
using System.Xml.Linq;
using Oracle.DataAccess.Client;
using Oracle.DataAccess.Types;

namespace ClinicHelper.Utils
{
    public class DatabaseManager
    {
        private readonly OracleConnection connection;
        private readonly OracleDataAdapter dataAdapter;
        private readonly object adapterLock;
        private DataSet dataSet;

        private const string CONNECTION_DATA = "User Id=clinic; Password=1111; Data Source=" +
            "(DESCRIPTION = (ADDRESS = (PROTOCOL = TCP) (HOST = localhost) (PORT = 1521))" +
            "(CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = xe)));";

        private static readonly Lazy<DatabaseManager> _instance = new Lazy<DatabaseManager>(() => new DatabaseManager());

        public static DatabaseManager Instance { get { return _instance.Value; } }
        private DatabaseManager() {
            connection = new OracleConnection(CONNECTION_DATA);
            connection.Open();
            dataAdapter = new OracleDataAdapter();
            adapterLock = new object();
            dataSet = new DataSet();
        }

        private void FillDataSet(ref DataSet dataSet, string tableName, OracleCommand selectCommand)
        {
            lock(adapterLock)
            {
                if (dataSet.Tables.Contains(tableName))
                {
                    dataSet.Tables[tableName].Rows.Clear();
                    dataSet.Tables[tableName].Columns.Clear();
                }
                dataAdapter.SelectCommand = selectCommand;
                dataAdapter.Fill(dataSet, tableName);
            }
        }

        private void UpdateByDataTable(ref DataTable dataTable)
        {
            lock(adapterLock)
            {
                DataTable updatedDataTable = dataTable.GetChanges(DataRowState.Modified | DataRowState.Added);
                if (updatedDataTable.HasErrors)
                    throw new Exception("There were errors with given update data");
                new OracleCommandBuilder(dataAdapter);
                dataAdapter.Update(updatedDataTable);
                dataSet.AcceptChanges();
            }
        }

        public OracleTransaction GetTransaction()
        {
            return connection.BeginTransaction();
        }

        public void FetchPatients(
            ref DataTable dataTable,
            int patientId = -1, 
            string nameLike = null)
        {
            string commandString = "SELECT " +
                    "patient_id, " +
                    "patient_name, " +
                    "joomin_num, " +
                    "address, " +
                    "telephone, " +
                    "mobile, " +
                    "note " +
                "FROM patient_info " +
                "{0}";

            List<string> whereConditions = new List<string>();
            if (patientId > 0)
                whereConditions.Add($"patient_id = {patientId}");
            if (nameLike != null)
                whereConditions.Add($"patient_name LIKE '%{nameLike}%'");

            string dsTableName;
            if (whereConditions.Count == 0)
            {
                commandString = String.Format(commandString, "");
                dsTableName = "patient_info";
            }
            else
            {
                commandString = String.Format(commandString, $"WHERE {String.Join(" AND ", whereConditions)}");
                dsTableName = "patient_info_filtered";
            }

            OracleCommand command = new OracleCommand(commandString, connection);
            FillDataSet(ref dataSet, dsTableName, command);
            dataTable = dataSet.Tables[dsTableName];
        }

        public void UpdatePatients(
            ref DataTable dataTable)
        {
            UpdateByDataTable(ref dataTable);
        }

        //RETURNING 문법 - 생성된 Row의 특정 Column 값을 커맨드의 Parameter로 사용해 반환값으로 가져올 수 있음
        public int CreatePatientInfo(PatientData patientData)
        {
            string commandString =
                "INSERT INTO patient_info " +
                "VALUES (PATIENT_ID_SEQ.NEXTVAL, :name, :jumin_no, :address, :tel, :mobile, :note) " +
                "RETURNING patient_id INTO :retval ";
            OracleCommand command = new OracleCommand(commandString, connection);
            command.BindByName = true;

            command.Parameters.Add(new OracleParameter("name", OracleDbType.Varchar2, 10)).Value = patientData.Name;
            command.Parameters.Add(new OracleParameter("jumin_no", OracleDbType.Varchar2, 15)).Value = patientData.JoominNum;
            command.Parameters.Add(new OracleParameter("address", OracleDbType.Varchar2, 30)).Value = patientData.Address;
            command.Parameters.Add(new OracleParameter("tel", OracleDbType.Varchar2, 15)).Value = patientData.Telephone;
            command.Parameters.Add(new OracleParameter("mobile", OracleDbType.Varchar2, 15)).Value = patientData.Mobile;
            command.Parameters.Add(new OracleParameter("note", OracleDbType.Varchar2, 30)).Value = patientData.Note;
            command.Parameters.Add("retval", OracleDbType.Int32, ParameterDirection.ReturnValue);
            command.ExecuteNonQuery();

            return ((OracleDecimal)command.Parameters["retval"].Value).ToInt32();
        }

        public PatientData FetchSinglePatientData(
            int patientID)
        {
            string commandString = "SELECT * FROM patient_info WHERE patient_id = :patient_id";
            OracleCommand command = new OracleCommand(commandString, connection);
            command.Parameters.Add("patient_id", OracleDbType.Int32).Value = patientID;

            var reader = command.ExecuteReader();
            reader.Read();

            return new PatientData()
            {
                PatientID = Convert.ToInt32(reader.GetDecimal(0)),
                Name = reader.GetString(1),
                JoominNum = reader.GetString(2),
                Address = reader.GetString(3),
                Telephone = reader.GetString(4),
                Mobile = reader.GetString(5),
                Note = reader.GetValue(6) == DBNull.Value ? String.Empty : reader.GetString(6)
            };
        }

        public void FetchDiagnosisRegistrations(
            ref DataTable dataTable, 
            int? patientId = null, 
            string patientName = null, 
            DateTime? startDT = null, 
            DateTime? endDT = null,
            int diagnosisStatus = -1,
            bool useSeparatedTable = false)
        {
            OracleCommand command = new OracleCommand();
            command.Connection = connection;

            string commandString = "SELECT " +
                    "DR.registration_id, " +
                    "PI.patient_id, " +
                    "PI.patient_name, " +
                    "DR.register_datetime, " +
                    "DR.patient_status, " +
                    "DR.diagnosis_done " +
                "FROM patient_info PI, diagnosis_registration DR " +
                "WHERE DR.patient_id = PI.patient_id {0}{1}{2}{3}{4}" +
                "ORDER BY DR.registration_id DESC";

            string patientIdCondition = "";
            if (patientId.HasValue)
            {
                patientIdCondition = "AND PI.patient_id = :patient_id ";
                command.Parameters.Add("patient_id", OracleDbType.Int32).Value = patientId.Value;
            }

            string patientNameCondition = "";
            if (!String.IsNullOrEmpty(patientName))
            {
                patientNameCondition = "AND PI.patient_name LIKE :patient_id ";
                command.Parameters.Add("patient_id", OracleDbType.Varchar2, 10).Value = $"%{patientName}%";
            }

            string startCondition = "";
            if (startDT.HasValue)
            {
                startCondition = "AND DR.register_datetime >= trunc(:start_dt) ";
                command.Parameters.Add("start_dt", OracleDbType.TimeStamp).Value = startDT.Value;
            }
            
            string endCondition = "";
            if (endDT.HasValue)
            {
                endCondition = "AND DR.register_datetime < (trunc(:end_dt) + 1) ";
                command.Parameters.Add("end_dt", OracleDbType.TimeStamp).Value = endDT.Value;
            }

            string statusCondition = "";
            if (diagnosisStatus != -1)
            {
                statusCondition = "AND DR.diagnosis_done = :diagnosis_status ";
                command.Parameters.Add("diagnosis_status", OracleDbType.Int32).Value = diagnosisStatus;
            }

            commandString = String.Format(commandString, patientIdCondition, patientNameCondition, startCondition, endCondition, statusCondition);
            command.CommandText = commandString;

            string dsTableName = useSeparatedTable ? "diagnosis_registrations_filtered" : "diagnosis_registrations";
            FillDataSet(ref dataSet, dsTableName, command);
            dataTable = dataSet.Tables[dsTableName];
        }

        //RETURNING 문법 - 생성된 Row의 특정 Column 값을 커맨드의 Parameter로 사용해 반환값으로 가져올 수 있음
        public int CreateDiagnosisRegistration(
            int patientId,
            string patientStatus)
        {
            string commandString = 
                "INSERT INTO diagnosis_registration " +
                "VALUES (REGISTRATION_ID_SEQ.NEXTVAL, :patient_id, CURRENT_TIMESTAMP, :patient_status, 0) " +
                "RETURNING registration_id INTO :retval ";

            OracleCommand command = new OracleCommand(commandString, connection);
            command.BindByName = true;
            command.Parameters.Clear();
            command.Parameters.Add(new OracleParameter("patient_id", OracleDbType.Decimal)).Value = patientId;
            command.Parameters.Add(new OracleParameter("patient_status", OracleDbType.Varchar2, 40)).Value = patientStatus;
            command.Parameters.Add("retval", OracleDbType.Int32, ParameterDirection.ReturnValue);

            command.ExecuteNonQuery();
            return ((OracleDecimal) command.Parameters["retval"].Value).ToInt32();
        }

        public int UpdateDiagnosisRegistrationStatus(
            int diagnosisRegistrationID,
            int diagnosisStatus,
            OracleTransaction transaction = null)
        {
            string commandString = "UPDATE diagnosis_registration SET " +
                "diagnosis_done = :diagnosis_status " +
                "WHERE registration_id = :registration_id ";
            OracleCommand command = new OracleCommand(commandString, connection);
            command.BindByName = true;
            if (transaction != null)
                command.Transaction = transaction;
            command.Parameters.Clear();

            command.Parameters.Add(new OracleParameter("diagnosis_status", OracleDbType.Int32)).Value = diagnosisStatus;
            command.Parameters.Add(new OracleParameter("registration_id", OracleDbType.Int32)).Value = diagnosisRegistrationID;
            return command.ExecuteNonQuery();
        }

        public DiagnosisRegistrationData FetchSingleDiagnosisRegistrationData(
            int diagnosisRegistrationID)
        {
            string commandString = "SELECT * FROM diagnosis_registration WHERE registration_id = :registration_id";
            OracleCommand command = new OracleCommand(commandString, connection);
            command.Parameters.Add("registration_id", OracleDbType.Int32).Value = diagnosisRegistrationID;

            var reader = command.ExecuteReader();
            reader.Read();
            DiagnosisRegistrationData diagnosisRegistrationData = new DiagnosisRegistrationData
            {
                RegistrationID = Convert.ToInt32(reader.GetDecimal(0)),
                PatientID = Convert.ToInt32(reader.GetDecimal(1)),
                RegisterDateTime = reader.GetDateTime(2),
                PatientStatus = reader.GetValue(3) == DBNull.Value ? String.Empty : reader.GetString(3),
                DiagnosisDone = Convert.ToBoolean(reader.GetDecimal(4))
            };
            return diagnosisRegistrationData;
        }

        public int CreateDiagnosisRecord(
            DiagnosisRecordData diagnosisRecordData,
            OracleTransaction transaction = null)
        {
            string commandString =
                "INSERT INTO diagnosis_record " +
                "VALUES (:registration_id, :diagnosis_dt, :kcd_code, :clinic_name, :doctor_name, :doctor_comment)";
            OracleCommand command = new OracleCommand(commandString, connection);
            if (transaction != null)
                command.Transaction = transaction;

            command.Parameters.Add("registration_id", OracleDbType.Int32).Value = diagnosisRecordData.RegistrationID;
            command.Parameters.Add("diagnosis_dt", OracleDbType.TimeStamp).Value = diagnosisRecordData.DiagnosisDateTime;
            command.Parameters.Add("kcd_code", OracleDbType.Varchar2, 5).Value = diagnosisRecordData.KCDCode;
            command.Parameters.Add("clinic_name", OracleDbType.Varchar2, 30).Value = diagnosisRecordData.ClinicName;
            command.Parameters.Add("doctor_name", OracleDbType.Varchar2, 10).Value = diagnosisRecordData.DoctorName;
            command.Parameters.Add("doctor_comment", OracleDbType.Varchar2, 256).Value = diagnosisRecordData.DoctorComment;

            return command.ExecuteNonQuery();
        }

        public DiagnosisRecordData? FetchSingleDiagnosisRecord(
            int diagnosisRegistrationID)
        {
            string commandString = "SELECT * FROM diagnosis_record WHERE registration_id = :registration_id";
            OracleCommand command = new OracleCommand(commandString, connection);
            command.Parameters.Add("registration_id", OracleDbType.Int32).Value = diagnosisRegistrationID;

            var reader = command.ExecuteReader();
            if (!reader.Read())
                return null;
            DiagnosisRecordData diagnosisRecordData = new DiagnosisRecordData();
            diagnosisRecordData.RegistrationID = Convert.ToInt32(reader.GetDecimal(0));
            diagnosisRecordData.DiagnosisDateTime = reader.GetDateTime(1);
            diagnosisRecordData.KCDCode = reader.GetString(2);
            diagnosisRecordData.ClinicName = reader.GetString(3);
            diagnosisRecordData.DoctorName = reader.GetString(4);
            diagnosisRecordData.DoctorComment = reader.GetValue(5) == DBNull.Value ? String.Empty : reader.GetString(5);
            return diagnosisRecordData;
        }

        public void CreateMedicinePrescription(
            int diagnosisRegistrationID, 
            List<MedicinePrescriptionData> prescribedMedicines, 
            OracleTransaction transaction = null)
        {
            string commandString =
                "INSERT INTO prescribed_medicines " +
                "VALUES (:registration_id, :medicine_code, :single_dose, :daily_dose, :total_amount)";

            foreach (MedicinePrescriptionData data in prescribedMedicines)
            {
                OracleCommand command = new OracleCommand(commandString, connection);
                if (transaction != null)
                    command.Transaction = transaction;
                command.Parameters.Add("registration_id", OracleDbType.Int32).Value = diagnosisRegistrationID;
                command.Parameters.Add("medicine_code", OracleDbType.Int32).Value = data.MedicineCode;
                command.Parameters.Add("single_dose", OracleDbType.Int32).Value = data.SingleDose;
                command.Parameters.Add("daily_dose", OracleDbType.Int32).Value = data.DailyDose;
                command.Parameters.Add("total_amount", OracleDbType.Int32).Value = data.TotalAmount;

                command.ExecuteNonQuery();
            }
        }

        public void FetchMedicinePrescriptions(
            ref DataTable dataTable, 
            int diagnosisRegistrationID)
        {
            string commandString = 
                "SELECT " +
                    "MI.medicine_code, " +
                    "MI.medicine_name, " +
                    "PM.daily_dose, " +
                    "PM.total_amount " +
                "FROM " +
                    "prescribed_medicines PM, " +
                    "medicine_info MI " +
                "WHERE registration_id = :registration_id " +
                    "AND PM.medicine_code = MI.medicine_code";

            OracleCommand command = new OracleCommand(commandString, connection);
            command.Parameters.Add("registration_id", OracleDbType.Int32).Value = diagnosisRegistrationID;

            FillDataSet(ref dataSet, "prescribed_medicines", command);
            dataTable = dataSet.Tables["prescribed_medicines"];
        }

        public void CreateTreatementPrescription(
            int diagnosisRegistrationID, 
            List<TreatmentPrescriptionData> prescribedTreatments, 
            OracleTransaction transaction = null)
        {
            string commandString =
                "INSERT INTO prescribed_treatments " +
                "VALUES (:registration_id, :treatment_code, :total_count)";

            foreach (TreatmentPrescriptionData data in prescribedTreatments)
            {
                OracleCommand command = new OracleCommand(commandString, connection);
                if (transaction != null)
                    command.Transaction = transaction;
                command.Parameters.Add("registration_id", OracleDbType.Int32).Value = diagnosisRegistrationID;
                command.Parameters.Add("treatment_code", OracleDbType.Int32).Value = data.TreatmentCode;
                command.Parameters.Add("total_count", OracleDbType.Int32).Value = data.TotalCount;

                command.ExecuteNonQuery();
            }
        }

        public void FetchTreatmentPrescriptions(
            ref DataTable dataTable, 
            int diagnosisRegistrationID)
        {
            string commandString =
                "SELECT " +
                    "TI.treatment_code, " +
                    "TI.treatment_name, " +
                    "PT.total_count " +
                "FROM " +
                    "prescribed_treatments PT, " +
                    "treatment_info TI " +
                "WHERE registration_id = :registration_id " +
                    "AND PT.treatment_code = TI.treatment_code";

            OracleCommand command = new OracleCommand(commandString, connection);
            command.Parameters.Add("registration_id", OracleDbType.Int32).Value = diagnosisRegistrationID;

            FillDataSet(ref dataSet, "prescribed_treatments", command);
            dataTable = dataSet.Tables["prescribed_treatments"];
        }

        public int CreatePaymentInfo(
            PaymentData paymentData, 
            OracleTransaction transaction = null)
        {
            string commandString = "INSERT INTO payment_info " +
                "VALUES (:registration_id, :total_diagnosis_cost, :total_treatment_cost, :payment_done)";

            OracleCommand command = new OracleCommand(commandString, connection);
            command.BindByName = true;
            if (transaction != null)
                command.Transaction = transaction;

            command.Parameters.Clear();
            command.Parameters.Add(new OracleParameter("registration_id", OracleDbType.Int32)).Value = paymentData.RegistrationID;
            command.Parameters.Add(new OracleParameter("total_diagnosis_cost", OracleDbType.Int32)).Value = paymentData.TotalDiagnosisCost;
            command.Parameters.Add(new OracleParameter("total_treatment_cost", OracleDbType.Int32)).Value = paymentData.TotalTreatmentCost;
            command.Parameters.Add(new OracleParameter("payment_done", OracleDbType.Int32)).Value = paymentData.PaymentDone;

            return command.ExecuteNonQuery();
        }

        public void FetchPaymentInfoTable(
            ref DataTable dataTable, 
            int paymentStatus = -1, 
            DateTime? startDT = null, 
            DateTime? endDT = null)
        {
            OracleCommand command = new OracleCommand()
            {
                Connection = connection,
                BindByName = true
            };

            string commandString =
                "SELECT " +
                    "DR.registration_id, " +
                    "patient.patient_name, " +
                    "(payment.total_diagnosis_cost + payment.total_treatment_cost), " +
                    "payment.payment_done " +
                "FROM " +
                    "diagnosis_registration DR, " +
                    "patient_info patient, " +
                    "payment_info payment " +
                "WHERE " +
                    "payment.registration_id = DR.registration_id " +
                    "AND patient.patient_id = DR.patient_id " +
                    "{0}{1}{2}" +
                "ORDER BY " +
                    "DR.registration_id DESC ";

            string statusCondition = "";
            if (paymentStatus != -1)
            {
                statusCondition = "AND payment.payment_done = :status ";
                command.Parameters.Add("status", OracleDbType.Int32).Value = paymentStatus;
            }
            
            string startCondition = "";
            if (startDT.HasValue)
            {
                startCondition = "AND DR.register_datetime >= trunc(:start_dt) ";
                command.Parameters.Add("start_dt", OracleDbType.TimeStamp).Value = startDT.Value;
            }

            string endCondition = "";
            if (endDT.HasValue)
            {
                endCondition = "AND DR.register_datetime < (trunc(:end_dt) + 1) ";
                command.Parameters.Add("end_dt", OracleDbType.TimeStamp).Value = endDT.Value;
            }

            commandString = String.Format(commandString, statusCondition, startCondition, endCondition);
            command.CommandText = commandString;

            FillDataSet(ref dataSet, "payment_info", command);
            dataTable = dataSet.Tables["payment_info"];
        }


        public int UpdatePaymentStatus(
            int registrationId, 
            int paymentStatus)
        {
            string commandString = "UPDATE payment_info SET " +
                "payment_done = :payment_status " +
                "WHERE registration_id = :registration_id ";

            OracleCommand command = new OracleCommand(commandString, connection);
            command.BindByName = true;
            command.Parameters.Clear();

            command.Parameters.Add(new OracleParameter("payment_status", OracleDbType.Int32)).Value = paymentStatus;
            command.Parameters.Add(new OracleParameter("registration_id", OracleDbType.Int32)).Value = registrationId;
            return command.ExecuteNonQuery();
        }

        public int UpdateOrInsertDiseaseData(
            DiseaseData diseaseData)
        {
            OracleCommand command = new OracleCommand()
            {
                Connection = connection,
                CommandText = "UPSERT_DISEASE_INFO",
                CommandType = CommandType.StoredProcedure,
                BindByName = true
            };

            command.Parameters.Clear();
            command.Parameters.Add(new OracleParameter("inputKcdCode", OracleDbType.Varchar2, 5)).Value = diseaseData.KCDCode;
            command.Parameters.Add(new OracleParameter("inputDiseaseName", OracleDbType.Varchar2, 40)).Value = diseaseData.Name;
            command.Parameters.Add(new OracleParameter("inputUnitCost", OracleDbType.Int32)).Value = diseaseData.DiagnosisCost;

            return command.ExecuteNonQuery();
        }

        public int GetTotalTreatmentCost(
            List<TreatmentPrescriptionData> treatmentPrescriptions)
        {
            string commandString = "SELECT SUM(unit_treatment_cost) FROM treatment_info WHERE treatment_code in ({0})";
            int[] treatmentCodes = treatmentPrescriptions.Select(x => x.TreatmentCode).ToArray();
            commandString = String.Format(commandString, String.Join(", ", treatmentCodes));

            OracleCommand command = new OracleCommand(commandString, connection);
            return Convert.ToInt32(command.ExecuteScalar());
        }
        
        public void FetchDiseaseDataTable(
            ref DataTable dataTable, 
            string KCDCode = null, 
            string diseaseName = null)
        {
            OracleCommand command = new OracleCommand();
            command.Connection = connection;

            string commandString = "SELECT * FROM disease_info {0}";
            string whereConditions = "";

            string kcdCodeCondition = "";
            if (!string.IsNullOrEmpty(KCDCode))
            {
                kcdCodeCondition = "kcd_code LIKE :kcd_code ";
                command.Parameters.Add("kcd_code", OracleDbType.Varchar2, 5).Value = $"%{KCDCode}%";
            }

            string diseaseNameCondition = "";
            if (!string.IsNullOrEmpty(diseaseName))
            {
                diseaseNameCondition = "disease_name LIKE :disease_name ";
                if (!string.IsNullOrEmpty(KCDCode))
                    diseaseNameCondition = "AND " + diseaseNameCondition;
                command.Parameters.Add("disease_name", OracleDbType.Varchar2, 60).Value = $"%{diseaseName}%";
            }

            if (!string.IsNullOrEmpty(KCDCode) || !string.IsNullOrEmpty(diseaseName))
            {
                whereConditions = String.Format("WHERE {0}{1}", kcdCodeCondition, diseaseNameCondition);
            }
            commandString = String.Format(commandString, whereConditions);
            command.CommandText = commandString;

            FillDataSet(ref dataSet, "disease_info", command);
            dataTable = dataSet.Tables["disease_info"];
        }

        public DiseaseData FetchSingleDiseaseData(
            string KCDCode)
        {
            string commandString = "SELECT * FROM disease_info  WHERE kcd_code = :kcd_code";
            OracleCommand command = new OracleCommand(commandString, connection);
            command.Parameters.Add("kcd_code", OracleDbType.Varchar2, 5).Value = KCDCode;

            var reader = command.ExecuteReader();
            reader.Read();
            return new DiseaseData()
            {
                KCDCode = reader.GetString(0),
                Name = reader.GetString(1),
                DiagnosisCost = Convert.ToInt32(reader.GetDecimal(2))
            };
        }

        public int UpdateOrInsertMedicineData(
            MedicineData medicineData)
        {
            OracleCommand command = new OracleCommand()
            {
                Connection = connection,
                CommandText = "UPSERT_MEDICINE_INFO",
                CommandType = CommandType.StoredProcedure,
                BindByName = true
            };

            command.Parameters.Clear();
            command.Parameters.Add(new OracleParameter("inputCode", OracleDbType.Int32)).Value = medicineData.Code;
            command.Parameters.Add(new OracleParameter("inputName", OracleDbType.Varchar2, 20)).Value = medicineData.Name;

            return command.ExecuteNonQuery();
        }
        
        public void FetchMedicineDataTable(
            ref DataTable dataTable, 
            int? medicineID = null, 
            string medicineName = null)
        {
            OracleCommand command = new OracleCommand()
            {
                Connection = connection,
                BindByName = true,
            };

            string commandString = "SELECT * FROM medicine_info {0}";
            string whereCondition = "";

            string idCondition = "";
            if (medicineID.HasValue)
            {
                idCondition = "medicine_code = :code ";
                command.Parameters.Add("code", OracleDbType.Int32).Value = medicineID.Value;
            }

            string nameCondition = "";
            if (!String.IsNullOrEmpty(medicineName))
            {
                nameCondition = "medicine_name LIKE :name ";
                if (medicineID.HasValue)
                    nameCondition = "AND " + nameCondition;
                command.Parameters.Add("name", OracleDbType.Varchar2, 20).Value = $"%{medicineName}%";
            }

            if (medicineID.HasValue || !String.IsNullOrEmpty(medicineName))
                whereCondition = String.Format("WHERE {0}{1}", idCondition, nameCondition);

            commandString = String.Format(commandString, whereCondition);
            command.CommandText = commandString;

            FillDataSet(ref dataSet, "medicine_info", command);
            dataTable = dataSet.Tables["medicine_info"];
        }

        public MedicineData FetchSingleMedicineData(
            int medicineID)
        {
            string commandString = "SELECT * FROM medicine_info  WHERE medicine_code = :medicine_id";
            OracleCommand command = new OracleCommand(commandString, connection);
            command.Parameters.Add("medicine_id", OracleDbType.Int32).Value = medicineID;

            var reader = command.ExecuteReader();
            reader.Read();
            return new MedicineData()
            {
                Code = Convert.ToInt32(reader.GetDecimal(0)),
                Name = reader.GetString(1)
            };
        }

        public int UpdateOrInsertTreatmentData(
            TreatmentData treatmentData)
        {
            OracleCommand command = new OracleCommand()
            {
                Connection = connection,
                CommandText = "UPSERT_TREATMENT_INFO",
                CommandType = CommandType.StoredProcedure,
                BindByName = true
            };

            command.Parameters.Clear();
            command.Parameters.Add(new OracleParameter("inputCode", OracleDbType.Int32)).Value = treatmentData.Code;
            command.Parameters.Add(new OracleParameter("inputName", OracleDbType.Varchar2, 40)).Value = treatmentData.Name;
            command.Parameters.Add(new OracleParameter("inputCost", OracleDbType.Int32)).Value = treatmentData.UnitCost;

            return command.ExecuteNonQuery();
        }

        public void FetchTreatmentDataTable(
            ref DataTable dataTable,
            int? treatmentCode = null,
            string treatmentName = null)
        {
            OracleCommand command = new OracleCommand()
            {
                Connection = connection,
                BindByName = true,
            };

            string commandString = "SELECT * " +
                "FROM treatment_info {0}";

            string whereCondition = "";

            string idCondition = "";
            if (treatmentCode.HasValue)
            {
                idCondition = "treatment_code = :code ";
                command.Parameters.Add("code", OracleDbType.Int32).Value = treatmentCode.Value;
            }

            string nameCondition = "";
            if (!String.IsNullOrEmpty(treatmentName))
            {
                nameCondition = "treatment_name LIKE :name ";
                if (treatmentCode.HasValue)
                    nameCondition = "AND " + nameCondition;
                command.Parameters.Add("name", OracleDbType.Varchar2, 20).Value = $"%{treatmentName}%";
            }
            
            if (treatmentCode.HasValue || !String.IsNullOrEmpty(treatmentName))
                whereCondition = String.Format("WHERE {0}{1}", idCondition, nameCondition);

            commandString = String.Format(commandString, whereCondition);
            command.CommandText = commandString;

            FillDataSet(ref dataSet, "treatment_info", command);
            dataTable = dataSet.Tables["treatment_info"];
        }

        public TreatmentData FetchSingleTreatmentData(
            int treatmentID)
        {
            string commandString = "SELECT * FROM treatment_info WHERE treatment_code = :treatment_id";
            OracleCommand command = new OracleCommand(commandString, connection);
            command.Parameters.Add("treatment_id", OracleDbType.Int32).Value = treatmentID;

            var reader = command.ExecuteReader();
            reader.Read();
            return new TreatmentData()
            {
                Code = Convert.ToInt32(reader.GetDecimal(0)),
                Name = reader.GetString(1),
                UnitCost = Convert.ToInt32(reader.GetDecimal(2))
            };
        }

        // groupByMode
        // 0 - Year, 1 - Month, 2 - Day
        public void FetchStatistics(ref DataTable dataTable, int groupByMode)
        {
            OracleCommand command = new OracleCommand();
            command.Connection = connection;

            string commandString =
                @"SELECT
                    EXTRACT(year from DR.register_datetime) as year,{0}{1}
                    COUNT(DR.registration_id),
                    SUM(PAYMENT.TOTAL_DIAGNOSIS_COST),
                    SUM(PAYMENT.TOTAL_TREATMENT_COST),
                    SUM(PAYMENT.TOTAL_DIAGNOSIS_COST + PAYMENT.TOTAL_TREATMENT_COST)
                FROM
                    diagnosis_registration DR, payment_info PAYMENT
                WHERE
                    DR.registration_id = PAYMENT.registration_id
                GROUP BY
                    EXTRACT(year from DR.register_datetime){2}{3}
                ORDER BY
                    EXTRACT(year from DR.register_datetime) DESC{4}{5} ";

            string monthSelect = "";
            string monthGroupBy = "";
            string monthOrderBy = "";
            if (groupByMode >= 1)
            {
                monthSelect = " EXTRACT(month from DR.register_datetime) as month,";
                monthGroupBy = ", EXTRACT(month from DR.register_datetime)";
                monthOrderBy = ", EXTRACT(month from DR.register_datetime) DESC";
            }

            string daySelect = "";
            string dayGroupBy = "";
            string dayOrderBy = "";
            if (groupByMode >= 2)
            {
                daySelect = " EXTRACT(day from DR.register_datetime) as day,";
                dayGroupBy = ", EXTRACT(day from DR.register_datetime)";
                dayOrderBy = ", EXTRACT(day from DR.register_datetime) DESC";
            }

            commandString = String.Format(commandString, monthSelect, daySelect, monthGroupBy, dayGroupBy, monthOrderBy, dayOrderBy);
            command.CommandText = commandString;

            FillDataSet(ref dataSet, "statistics", command);
            dataTable = dataSet.Tables["statistics"];
        }
    }
}
