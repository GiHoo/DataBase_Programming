using System;
using System.Data;
using System.Windows.Forms;

using Microsoft.VisualBasic.FileIO;

using ClinicHelper.Utils;
using ClinicHelper.FrontDeskApp.PatientManagement;
using ClinicHelper.FrontDeskApp.BaseDataManagement;
using ClinicHelper.FrontDeskApp.DiagnosisRecordManagement;

namespace ClinicHelper.FrontDeskApp
{

    public partial class MainForm : Form
    {

        DatabaseManager dbManager;
        private DataTable patientTable; // table for storing single patient data
        private DataTable diagnosisRegistrationTable;

        public MainForm()
        {
            InitializeComponent();
            dbManager = DatabaseManager.Instance;
            patientTable = new DataTable();
            diagnosisRegistrationTable= new DataTable();
        }


        private void EnableEditor(bool enable)
        {
            textBox_PatientJuminNo1.Enabled = enable;
            textBox_PatientJuminNo2.Enabled = enable;
            textBox_PatientTel.Enabled = enable;
            textBox_PatientMobile.Enabled = enable;
            textBox_PatientBirthDate.Enabled = enable;
            textBox_PatientAgeSex.Enabled = enable;
            textBox_PatientAddress.Enabled = enable;
            textBox_PatientNote.Enabled = enable;
            textBox_PatientStatus.Enabled = enable;
            button_RegisterDiagnosis.Enabled = enable;
            if (!enable) ClearEditor();
        }

        private void FillEditor(DataRow row)
        {
            ClearEditor();
            textBox_PatientID.Text = row["patient_id"].ToString();
            textBox_PatientName.Text = row["patient_name"].ToString();
            string[] juminNoTokens = row["joomin_num"].ToString().Split('-');
            textBox_PatientJuminNo1.Text = juminNoTokens[0];
            textBox_PatientJuminNo2.Text = juminNoTokens[1];
            textBox_PatientBirthDate.Text = CommonUtils.CalculateBirthDateFromJuminNum(juminNoTokens);
            textBox_PatientAgeSex.Text = CommonUtils.CalculateAgeSexFromJuminNum(juminNoTokens);
            textBox_PatientTel.Text = row["telephone"].ToString();
            textBox_PatientMobile.Text = row["telephone"].ToString();
            textBox_PatientAddress.Text = row["address"].ToString();
            textBox_PatientNote.Text = row["note"].ToString();
            EnablePatientInfoSaveButton(false);
        }

        private void ClearEditor()
        {
            textBox_PatientID.Clear();
            textBox_PatientName.Clear();
            textBox_PatientJuminNo1.Clear();
            textBox_PatientJuminNo2.Clear();
            textBox_PatientTel.Clear();
            textBox_PatientMobile.Clear();
            textBox_PatientAgeSex.Clear();
            textBox_PatientAddress.Clear();
            textBox_PatientNote.Clear();
            textBox_PatientStatus.Clear();
            EnablePatientInfoSaveButton(false);
        }

        private void EnablePatientInfoSaveButton(bool enable)
        {
            if (enable)
            {
                if (String.IsNullOrEmpty(textBox_PatientID.Text) ||
                    String.IsNullOrEmpty(textBox_PatientName.Text) ||
                    String.IsNullOrEmpty(textBox_PatientJuminNo1.Text) ||
                    String.IsNullOrEmpty(textBox_PatientJuminNo2.Text) ||
                    String.IsNullOrEmpty(textBox_PatientAddress.Text) ||
                    String.IsNullOrEmpty(textBox_PatientTel.Text))
                {
                    button_SavePatient.Enabled = false;
                    return;
                }
            }
            button_SavePatient.Enabled = enable;
        }

        private void EditorCommonTextChangedEvent(object sender, EventArgs e)
        {
            EnablePatientInfoSaveButton(true);
            
        }

        private void SetupColumns()
        {
            dataGridView1.Columns["REGISTRATION_ID"].HeaderText = "접수번호";
            dataGridView1.Columns["REGISTRATION_ID"].Width = 75;
            dataGridView1.Columns["PATIENT_ID"].HeaderText = "환자 ID";
            dataGridView1.Columns["PATIENT_ID"].Width = 70;
            dataGridView1.Columns["PATIENT_NAME"].HeaderText = "환자명";
            dataGridView1.Columns["PATIENT_NAME"].Width = 90;
            dataGridView1.Columns["REGISTER_DATETIME"].HeaderText = "접수일시";
            dataGridView1.Columns["REGISTER_DATETIME"].Width = 130;
            dataGridView1.Columns["PATIENT_STATUS"].HeaderText = "환자상태";
            dataGridView1.Columns["DIAGNOSIS_DONE"].HeaderText = "진료완료";
            dataGridView1.Columns["DIAGNOSIS_DONE"].Width = 77;
        }

        private void RefreshDiagnosisRegistrationList()
        {
            dbManager.FetchDiagnosisRegistrations(ref diagnosisRegistrationTable, startDT: DateTime.Today, endDT: DateTime.Today);
            dataGridView1.DataSource = diagnosisRegistrationTable.DefaultView;
            SetupColumns();
        }
        private void MainForm_Load(object sender, EventArgs e)
        {
            RefreshDiagnosisRegistrationList();
        }

        private void textBox_PatientID_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                string text = textBox_PatientID.Text;
                if (string.IsNullOrEmpty(text))
                {
                    EnableEditor(false);
                    return;
                }
                PatientSearchForm searchForm = new PatientSearchForm(idCondition: Convert.ToInt32(text));
                if (searchForm.ShowDialog() == DialogResult.OK && searchForm.MatchingPatientId != -1)
                {
                    dbManager.FetchPatients(ref patientTable, patientId: searchForm.MatchingPatientId);
                    if (patientTable.Rows.Count == 1)
                    {
                        FillEditor(patientTable.Rows[0]);
                        EnableEditor(true);
                    }
                }
                else
                {
                    EnableEditor(false);
                }
            }
        }

        private void textBox_PatientName_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                string text = textBox_PatientName.Text;
                if (string.IsNullOrEmpty(text))
                {
                    EnableEditor(false);
                    return;
                }
                PatientSearchForm searchForm = new PatientSearchForm(nameCondition: text);
                if (searchForm.ShowDialog() == DialogResult.OK && searchForm.MatchingPatientId != -1)
                {
                    dbManager.FetchPatients(ref patientTable, patientId: searchForm.MatchingPatientId);
                    if (patientTable.Rows.Count == 1)
                    {
                        FillEditor(patientTable.Rows[0]);
                        EnableEditor(true);
                    }
                } else
                {
                    EnableEditor(false);
                }
            }
        }

        private void button_RegisterDiagnosis_Click(object sender, EventArgs e)
        {
            int patientId = Convert.ToInt32(textBox_PatientID.Text);
            int registrationId = dbManager.CreateDiagnosisRegistration(patientId, textBox_PatientStatus.Text);
            RefreshDiagnosisRegistrationList();
        }

        private void button_SavePatient_Click(object sender, EventArgs e)
        {
            DataRow row = patientTable.Rows[0];
            row["patient_name"] = textBox_PatientName.Text;
            row["joomin_num"] = $"{textBox_PatientJuminNo1.Text}-{textBox_PatientJuminNo2.Text}";
            row["telephone"] = textBox_PatientTel.Text;
            row["mobile"] = textBox_PatientMobile.Text;
            row["address"] = textBox_PatientAddress.Text;
            row["note"] = textBox_PatientNote.Text;

            dbManager.UpdatePatients(ref patientTable);
            FillEditor(row);
        }

        private void OpenRegisterPatientEvent(object sender, EventArgs e)
        {
            new PatientRegisterationForm().ShowDialog();
        }

        private void OpenSearchPatientEvent(object sender, EventArgs e)
        {
            PatientSearchForm searchForm = new PatientSearchForm();
            if (searchForm.ShowDialog() == DialogResult.OK && searchForm.MatchingPatientId != -1)
            {
                dbManager.FetchPatients(ref patientTable, patientId: searchForm.MatchingPatientId);
                if (patientTable.Rows.Count == 1)
                {
                    FillEditor(patientTable.Rows[0]);
                    EnableEditor(true);
                }
            }
        }

        private void OpenPaymentManagementEvent(object sender, EventArgs e)
        {
            new PaymentManagementForm().ShowDialog();
        }

        private void ToolStripMenuItem_ManageDiseaseData_Click(object sender, EventArgs e)
        {
            new DiseaseDataManagementForm().ShowDialog();
        }

        private void ToolStripMenuItem_ManageMedicineData_Click(object sender, EventArgs e)
        {
            new MedicineDataManagementForm().ShowDialog();
        }

        private void ToolStripMenuItem_ManageTreatmentData_Click(object sender, EventArgs e)
        {
            new TreatementDataManagementForm().ShowDialog();
        }

        private void ToolStripMenuItem_StatisticData_Click(object sender, EventArgs e)
        {
            new StatisticsForm().ShowDialog();
        }

        private void button_ViewDiagnosisRecords_Click(object sender, EventArgs e)
        {
            new ViewDiagnosisRecordsForm().ShowDialog();
        }

        private void dataGridView1_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            DataRow row = diagnosisRegistrationTable.Rows[e.RowIndex];
            int diagnosisRegistrationID = Convert.ToInt32(row["registration_id"]);

            new ViewDetailedDiagnosisRecord(diagnosisRegistrationID).ShowDialog();
        }
    }
}
