using System;
using System.Data;
using System.Linq;
using System.Windows.Forms;

using ClinicHelper.Utils;

namespace ClinicHelper.DoctorApp.BaseDataSearchForms
{
    public partial class DiseaseDataSearchForm : Form
    {

        private DatabaseManager dbManager;
        private DataTable diseaseInfoTable;

        public string SelectedKCDCode;

        public DiseaseDataSearchForm()
        {
            InitializeComponent();
            dbManager = DatabaseManager.Instance;
        }

        private void TranslateColumnHeader()
        {
            dataGridView1.Columns[0].HeaderText = "질병 코드";
            dataGridView1.Columns[1].HeaderText = "질병명";
            dataGridView1.Columns[2].HeaderText = "진찰 단가";
        }

        private void RefreshDiseaseList(string KCDCode = null, string diseaseName = null)
        {
            dbManager.FetchDiseaseDataTable(ref diseaseInfoTable, KCDCode, diseaseName);
            dataGridView1.DataSource = diseaseInfoTable.DefaultView;
            TranslateColumnHeader();
        }


        private void DiseaseDataManagementForm_Load(object sender, EventArgs e)
        {
            RefreshDiseaseList();
        }

        private void DiseaseDataManagementForm_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Escape)
            {
                this.Close();
            }
        }

        private void button_ApplyFilter_Click(object sender, EventArgs e)
        {
            RefreshDiseaseList(textBox_FilterKCDCode.Text, textBox_FilterDiseaseName.Text);
        }

        private void dataGridView1_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            this.SelectedKCDCode = diseaseInfoTable.Rows[e.RowIndex]["kcd_code"].ToString();
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
