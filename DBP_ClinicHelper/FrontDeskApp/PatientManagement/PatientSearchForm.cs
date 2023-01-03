using System;
using System.Data;
using System.Windows.Forms;

using ClinicHelper.Utils;

namespace ClinicHelper.FrontDeskApp.PatientManagement
{
    public partial class PatientSearchForm : Form
    {

        private int idCondition;
        private string nameCondition;
        public int MatchingPatientId;

        DatabaseManager dbManager;
        DataTable patientTable;

        public PatientSearchForm(int idCondition = -1, string nameCondition = null)
        {
            InitializeComponent();
            this.idCondition = idCondition;
            this.nameCondition = nameCondition;
            this.MatchingPatientId = -1;
            dbManager = DatabaseManager.Instance;
        }

        private void TranslateColumnHeader()
        {
            dataGridView.Columns["PATIENT_ID"].HeaderText = "환자 ID";
            dataGridView.Columns["PATIENT_ID"].Width = 80;
            dataGridView.Columns["PATIENT_NAME"].HeaderText = "환자명";
            dataGridView.Columns["PATIENT_NAME"].Width = 100;
            dataGridView.Columns["JOOMIN_NUM"].HeaderText = "주민등록번호";
            dataGridView.Columns["JOOMIN_NUM"].Width = 110;
            dataGridView.Columns["ADDRESS"].HeaderText = "주소";
            dataGridView.Columns["TELEPHONE"].HeaderText = "유선전화";
            dataGridView.Columns["TELEPHONE"].Width = 100;
            dataGridView.Columns["MOBILE"].HeaderText = "무선전화";
            dataGridView.Columns["MOBILE"].Width = 100;
            dataGridView.Columns["NOTE"].HeaderText = "비고";
        }

        private void PatientSearchForm_Load(object sender, EventArgs e)
        {
            if (idCondition != -1)
            {
                dbManager.FetchPatients(ref patientTable, patientId: idCondition);
                if (patientTable.Rows.Count == 1)
                {
                    this.MatchingPatientId = Convert.ToInt32(patientTable.Rows[0]["patient_id"]);
                    this.DialogResult = DialogResult.OK;
                    this.Close();
                    return;
                }

                radioButton_SearchByID.Checked = true;
                textBox_PatientID.Text = idCondition.ToString();
                dataGridView.DataSource = patientTable.DefaultView;

            } else if (nameCondition != null)
            {
                dbManager.FetchPatients(ref patientTable, nameLike: nameCondition);
                if (patientTable.Rows.Count == 1)
                {
                    this.MatchingPatientId = Convert.ToInt32(patientTable.Rows[0]["patient_id"]);
                    this.DialogResult = DialogResult.OK;
                    this.Close();
                    return;
                }
                radioButton_SearchByName.Checked = true;
                textBox_PatientName.Text = nameCondition;
                dataGridView.DataSource = patientTable.DefaultView;
            } else
            {
                dbManager.FetchPatients(ref patientTable);
                dataGridView.DataSource = patientTable.DefaultView;
            }
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

        private void dataGridView_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            this.MatchingPatientId = Convert.ToInt32(patientTable.Rows[e.RowIndex]["patient_id"]);
            this.DialogResult= DialogResult.OK;
            this.Close();
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
