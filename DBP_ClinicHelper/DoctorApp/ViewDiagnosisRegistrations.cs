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
    public partial class ViewDiagnosisRegistrations : Form
    {
        private DatabaseManager dbManager;
        private DataTable registrationTable;

        public int SelectedRegistrationID;

        public ViewDiagnosisRegistrations()
        {
            InitializeComponent();
            dbManager = DatabaseManager.Instance;
        }

        private void SetupColumns()
        {
            dataGridView1.Columns["REGISTRATION_ID"].HeaderText = "접수 ID";
            dataGridView1.Columns["REGISTRATION_ID"].Width = 80;
            dataGridView1.Columns["PATIENT_ID"].HeaderText = "환자 ID";
            dataGridView1.Columns["PATIENT_ID"].Width = 80;
            dataGridView1.Columns["PATIENT_NAME"].HeaderText = "환자명";
            dataGridView1.Columns["REGISTER_DATETIME"].HeaderText = "접수 시간";
            dataGridView1.Columns["REGISTER_DATETIME"].MinimumWidth = 180;
            dataGridView1.Columns["PATIENT_STATUS"].HeaderText = "환자 상태";
            dataGridView1.Columns["PATIENT_STATUS"].MinimumWidth = 180;
            dataGridView1.Columns["DIAGNOSIS_DONE"].HeaderText = "진료 완료";
            dataGridView1.Columns["DIAGNOSIS_DONE"].Width = 80;
        }

        private void dataGridView1_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            this.SelectedRegistrationID = Convert.ToInt32(registrationTable.Rows[e.RowIndex]["registration_id"]);
            this.DialogResult = DialogResult.OK;
            this.Close();
        }

        private void ViewDiagnosisRegistrations_Load(object sender, EventArgs e)
        {
            dbManager.FetchDiagnosisRegistrations(ref registrationTable, diagnosisStatus: 0, endDT: DateTime.Today);
            dataGridView1.DataSource = registrationTable;
            SetupColumns();
        }

        private void ViewDiagnosisRegistrations_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Escape)
            {
                this.Close();
            }
        }
    }
}
