using ClinicHelper.Utils;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ClinicHelper.DoctorApp
{
    public partial class ViewDetailedDiagnosisRecord : Form
    {
        private DatabaseManager dbManager;
        private int diagnosisRegistrationID;
        private PatientData patientData;
        private DiagnosisRegistrationData diagnosisRegistrationData;
        private DiagnosisRecordData diagnosisRecordData;
        private DataTable prescribedMedicineTable;
        private DataTable prescribedTreatmentTable;

        public ViewDetailedDiagnosisRecord(int diagnosisRegistrationID)
        {
            InitializeComponent();
            this.diagnosisRegistrationID = diagnosisRegistrationID;
            dbManager = DatabaseManager.Instance;
        }

        private void SetupColumns()
        {
            dataGridView1.Columns["MEDICINE_CODE"].HeaderText = "약품 코드";
            dataGridView1.Columns["MEDICINE_NAME"].HeaderText = "약품명";
            dataGridView1.Columns["DAILY_DOSE"].HeaderText = "일 복용량";
            dataGridView1.Columns["TOTAL_AMOUNT"].HeaderText = "총 처방량";

            dataGridView2.Columns["TREATMENT_CODE"].HeaderText = "행위 코드";
            dataGridView2.Columns["TREATMENT_NAME"].HeaderText = "행위 명";
            dataGridView2.Columns["TOTAL_COUNT"].HeaderText = "총 횟수";
        }
        private void ViewDetailedDiagnosisRecord_Load(object sender, EventArgs e)
        {
            diagnosisRegistrationData = dbManager.FetchSingleDiagnosisRegistrationData(diagnosisRegistrationID);

            textBox_RegisterDateTime.Text = diagnosisRegistrationData.RegisterDateTime.ToString();
            textBox_PatientStatus.Text = diagnosisRegistrationData.PatientStatus;

            patientData = dbManager.FetchSinglePatientData(diagnosisRegistrationData.PatientID);

            textBox_PatientID.Text = patientData.PatientID.ToString();
            textBox_PatientName.Text = patientData.Name.ToString();
            string[] juminNoTokens = patientData.JoominNum.ToString().Split('-');
            textBox_PatientJuminNo1.Text = juminNoTokens[0];
            textBox_PatientJuminNo2.Text = juminNoTokens[1];
            textBox_PatientBirthDate.Text = CommonUtils.CalculateBirthDateFromJuminNum(juminNoTokens);
            textBox_PatientAgeSex.Text = CommonUtils.CalculateAgeSexFromJuminNum(juminNoTokens);
            textBox_PatientTel.Text = patientData.Telephone.ToString();
            textBox_PatientMobile.Text = patientData.Mobile.ToString();
            textBox_PatientAddress.Text = patientData.Address.ToString();
            textBox_PatientNote.Text = patientData.Note.ToString();

            DiagnosisRecordData? temp = dbManager.FetchSingleDiagnosisRecord(diagnosisRegistrationID);
            if (!temp.HasValue) return;

            diagnosisRecordData = temp.Value;
            textBox_DoctorComment.Text = diagnosisRecordData.DoctorComment;
            textBox_DiagnosisDateTime.Text = diagnosisRecordData.DiagnosisDateTime.ToString();
            textBox_KCDCode.Text = diagnosisRecordData.KCDCode;
            textBox_ClinicName.Text = diagnosisRecordData.ClinicName;
            textBox_DoctorName.Text = diagnosisRecordData.DoctorName;

            dbManager.FetchMedicinePrescriptions(ref prescribedMedicineTable, diagnosisRegistrationID);
            dataGridView1.DataSource = prescribedMedicineTable;

            dbManager.FetchTreatmentPrescriptions(ref prescribedTreatmentTable, diagnosisRegistrationID);
            dataGridView2.DataSource = prescribedTreatmentTable;

            SetupColumns();
        }

        private void ViewDetailedDiagnosisRecord_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Escape)
            {
                this.Close();
            }
        }
    }
}
