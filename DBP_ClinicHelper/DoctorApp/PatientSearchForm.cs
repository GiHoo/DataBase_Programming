using System;
using System.Data;
using System.Windows.Forms;

using ClinicHelper.Utils;

namespace ClinicHelper.DoctorApp
{
    public partial class PatientSearchForm : Form
    {

        private int idCondition;
        private string nameCondition;

        DatabaseManager dbManager;
        DataTable patientTable;

        public PatientSearchForm(int idCondition = -1, string nameCondition = null)
        {
            InitializeComponent();
            this.idCondition = idCondition;
            this.nameCondition = nameCondition;
            dbManager = DatabaseManager.Instance;
        }

        private void TranslateColumnHeader()
        {
            dataGridView.Columns["PATIENT_ID"].HeaderText = "환자 ID";
            dataGridView.Columns["PATIENT_NAME"].HeaderText = "환자명";
            dataGridView.Columns["JOOMIN_NUM"].HeaderText = "주민등록번호";
            dataGridView.Columns["ADDRESS"].HeaderText = "주소";
            dataGridView.Columns["TELEPHONE"].HeaderText = "유선전화";
            dataGridView.Columns["MOBILE"].HeaderText = "무선전화";
            dataGridView.Columns["NOTE"].HeaderText = "비고";
        }

        private void PatientSearchForm_Load(object sender, EventArgs e)
        {

            dbManager.FetchPatients(ref patientTable);
            dataGridView.DataSource = patientTable.DefaultView;
            TranslateColumnHeader();
        }

        private void radioButton_SearchAll_CheckedChanged(object sender, EventArgs e)
        {
            textBox_PatientID.Enabled = false;
            textBox_PatientName.Enabled = false;
        }

        private void radioButton_SearchByID_CheckedChanged(object sender, EventArgs e)
        {
            textBox_PatientID.Enabled = radioButton_SearchByID.Checked;
        }

        private void radioButton_SearchByName_CheckedChanged(object sender, EventArgs e)
        {
            textBox_PatientName.Enabled = radioButton_SearchByName.Checked;
        }

        private void button_SearchPatient_Click(object sender, EventArgs e)
        {
            if (radioButton_SearchByID.Checked)
            {
                dbManager.FetchPatients(ref patientTable, patientId: Convert.ToInt32(textBox_PatientID.Text));
            } else if (radioButton_SearchByName.Checked)
            {
                dbManager.FetchPatients(ref patientTable, nameLike: textBox_PatientName.Text);
            } else
            {
                dbManager.FetchPatients(ref patientTable);
            }
            dataGridView.DataSource = patientTable.DefaultView;
            TranslateColumnHeader();
        }

        private void PatientSearchForm_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Escape)
            {
                this.Close();
            }
        }

        private void FilterTextBoxEnterEvent(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                button_SearchPatient.PerformClick();
            }
        }
    }
}
