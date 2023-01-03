using System;
using System.Data;
using System.Windows.Forms;

using ClinicHelper.Utils;

namespace ClinicHelper.DoctorApp.BaseDataSearchForms
{
    public partial class TreatmentDataSearchForm : Form
    {
        private DatabaseManager dbManager;
        private DataTable treatmentInfoTable;

        public int SelectedTreatementID;

        public TreatmentDataSearchForm()
        {
            InitializeComponent();
            dbManager = DatabaseManager.Instance;
        }

        private void SetupColumns()
        {
            dataGridView1.Columns["TREATMENT_CODE"].HeaderText = "행위 코드";
            dataGridView1.Columns["TREATMENT_CODE"].Width = 80;
            dataGridView1.Columns["TREATMENT_NAME"].HeaderText = "행위명";
            dataGridView1.Columns["TREATMENT_NAME"].MinimumWidth = 180;
            dataGridView1.Columns["UNIT_TREATMENT_COST"].HeaderText = "행위 단가";
        }

        private void RefreshTreatmentData(int? treatmentCode = null, string treatmentName = null)
        {
            dbManager.FetchTreatmentDataTable(ref treatmentInfoTable, treatmentCode, treatmentName);
            dataGridView1.DataSource = treatmentInfoTable.DefaultView;
            SetupColumns();
        }

        private void TreatementDataManagementForm_Load(object sender, EventArgs e)
        {
            RefreshTreatmentData();
        }

        private void TreatementDataManagementForm_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Escape)
            {
                this.Close();
            }
        }

        private void button_ApplyFilter_Click(object sender, EventArgs e)
        {
            int? treatmentCode = null;
            if (!String.IsNullOrEmpty(textBox_FilterCode.Text))
                treatmentCode = Convert.ToInt32(textBox_FilterCode.Text);

            RefreshTreatmentData(treatmentCode, textBox_FilterName.Text);
        }

        private void dataGridView1_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            this.SelectedTreatementID = Convert.ToInt32(treatmentInfoTable.Rows[e.RowIndex]["treatment_code"]);
            this.DialogResult = DialogResult.OK;
            this.Close();
        }

        private void EditorCommonKeyUpHandler(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                button_ApplyFilter.PerformClick();
            }
        }
    }
}
