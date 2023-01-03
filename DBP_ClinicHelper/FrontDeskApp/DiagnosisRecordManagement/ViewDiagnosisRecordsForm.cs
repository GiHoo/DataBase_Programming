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

namespace ClinicHelper.FrontDeskApp.DiagnosisRecordManagement
{
    public partial class ViewDiagnosisRecordsForm : Form
    {
        private DatabaseManager dbManager;
        private DataTable dataTable;

        public ViewDiagnosisRecordsForm()
        {
            InitializeComponent();
            dbManager = DatabaseManager.Instance;
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

        private void RefreshDiagnosisRecordData(int? patientID = null, string patientName = null, DateTime? startDT = null, DateTime? endDT = null)
        {
            dbManager.FetchDiagnosisRegistrations(ref dataTable, patientID, patientName, startDT, endDT, useSeparatedTable: true);
            dataGridView1.DataSource = dataTable;

            SetupColumns();
        }

        private void ViewDiagnosisRecordsForm_Load(object sender, EventArgs e)
        {
            RefreshDiagnosisRecordData(startDT: dateTimePicker_Start.Value, endDT: dateTimePicker_End.Value);
        }

        private void button_ApplyFilter_Click(object sender, EventArgs e)
        {
            int? patientID = null;
            if (!String.IsNullOrEmpty(textBox_PatientID.Text))
                patientID = Convert.ToInt32(textBox_PatientID.Text);

            RefreshDiagnosisRecordData(patientID, textBox_PatientName.Text, dateTimePicker_Start.Value, dateTimePicker_End.Value);
        }

        private void dataGridView1_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            DataRow row = dataTable.Rows[e.RowIndex];
            int diagnosisRegistrationID = Convert.ToInt32(row["registration_id"]);

            new ViewDetailedDiagnosisRecord(diagnosisRegistrationID).ShowDialog();
        }

        private void ViewDiagnosisRecordsForm_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Escape)
            {
                this.Close();
            }
        }
    }
}
