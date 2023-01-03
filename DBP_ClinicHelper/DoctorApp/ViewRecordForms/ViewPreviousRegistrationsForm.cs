using System;
using System.Data;
using System.Windows.Forms;

using ClinicHelper.Utils;

namespace ClinicHelper.DoctorApp.ViewRecordForms
{
    public partial class ViewPreviousRegistrationsForm : Form
    {
        private DatabaseManager dbManager;
        private DataTable dataTable;

        private PatientData targetPatientData;

        public ViewPreviousRegistrationsForm(PatientData patientData)
        {
            InitializeComponent();
            dbManager = DatabaseManager.Instance;
            this.targetPatientData = patientData;
        }
        private void SetupColumns()
        {
            dataGridView.Columns["REGISTRATION_ID"].HeaderText = "접수 ID";
            dataGridView.Columns["REGISTRATION_ID"].Width = 80;
            dataGridView.Columns["PATIENT_ID"].HeaderText = "환자 ID";
            dataGridView.Columns["PATIENT_ID"].Width = 80;
            dataGridView.Columns["PATIENT_NAME"].HeaderText = "환자명";
            dataGridView.Columns["REGISTER_DATETIME"].HeaderText = "접수 시간";
            dataGridView.Columns["REGISTER_DATETIME"].MinimumWidth = 180;
            dataGridView.Columns["PATIENT_STATUS"].HeaderText = "환자 상태";
            dataGridView.Columns["PATIENT_STATUS"].MinimumWidth = 180;
            dataGridView.Columns["DIAGNOSIS_DONE"].HeaderText = "진료 완료";
            dataGridView.Columns["DIAGNOSIS_DONE"].Width = 80;
        }

        private void RefreshRegistrationTable()
        {
            dbManager.FetchDiagnosisRegistrations(
                ref dataTable, 
                patientId: targetPatientData.PatientID, 
                startDT: dateTimePicker_Start.Value,
                endDT: dateTimePicker_End.Value,
                useSeparatedTable: true
                );
            dataGridView.DataSource = dataTable;
            SetupColumns();
        }

        private void dataGridView2_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            int registrationID = Convert.ToInt32(dataTable.Rows[e.RowIndex]["registration_id"]);
            new ViewDetailedDiagnosisRecord(registrationID).ShowDialog();
        }

        private void ViewPreviousRegistrationsForm_Load(object sender, EventArgs e)
        {
            dateTimePicker_Start.Value = DateTime.Today.AddYears(-1);
            RefreshRegistrationTable();
        }

        private void button_ApplyFilter_Click(object sender, EventArgs e)
        {
            RefreshRegistrationTable();
        }

        private void ViewPreviousRegistrationsForm_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Escape)
            {
                this.Close();
            }
        }
    }
}
