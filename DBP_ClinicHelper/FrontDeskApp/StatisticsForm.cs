using System;
using System.Data;
using System.Windows.Forms;

using ClinicHelper.Utils;

namespace ClinicHelper.FrontDeskApp
{
    public partial class StatisticsForm : Form
    {
        private DatabaseManager dbManager;
        private DataTable statisticsTable;

        public StatisticsForm()
        {
            InitializeComponent();
        }
        
        private void SetupColumns()
        {
            dataGridView1.Columns["YEAR"].HeaderText = "연도";
            dataGridView1.Columns["YEAR"].Width = 60;
            if (dataGridView1.Columns.Contains("MONTH"))
            {
                dataGridView1.Columns["MONTH"].HeaderText = "월";
                dataGridView1.Columns["MONTH"].Width = 40;
            }
            if (dataGridView1.Columns.Contains("DAY"))
            {
                dataGridView1.Columns["DAY"].HeaderText = "일";
                dataGridView1.Columns["DAY"].Width = 40;
            }

            dataGridView1.Columns["COUNT(DR.REGISTRATION_ID)"].HeaderText = "진료 수";
            dataGridView1.Columns["COUNT(DR.REGISTRATION_ID)"].Width = 70;
            dataGridView1.Columns["SUM(PAYMENT.TOTAL_DIAGNOSIS_COST)"].HeaderText = "진찰 매출";
            dataGridView1.Columns["SUM(PAYMENT.TOTAL_DIAGNOSIS_COST)"].MinimumWidth = 120;
            dataGridView1.Columns["SUM(PAYMENT.TOTAL_TREATMENT_COST)"].HeaderText = "의료 행위 매출";
            dataGridView1.Columns["SUM(PAYMENT.TOTAL_TREATMENT_COST)"].MinimumWidth = 120;
            dataGridView1.Columns["SUM(PAYMENT.TOTAL_DIAGNOSIS_COST+PAYMENT.TOTAL_TREATMENT_COST)"].HeaderText = "매출 합";
            dataGridView1.Columns["SUM(PAYMENT.TOTAL_DIAGNOSIS_COST+PAYMENT.TOTAL_TREATMENT_COST)"].MinimumWidth = 120;
        }

        private void RefreshStatisticsList()
        {
            int groupByMode = 0;
            if (radioButton_ByMonth.Checked)
                groupByMode = 1;
            else if (radioButton_ByDay.Checked)
                groupByMode = 2;
            dbManager.FetchStatistics(ref statisticsTable, groupByMode);
            dataGridView1.DataSource = statisticsTable;
            SetupColumns();
        }

        private void StatisticsForm_Load(object sender, EventArgs e)
        {
            dbManager = DatabaseManager.Instance;
            RefreshStatisticsList();
        }

        private void StatisticsForm_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Escape)
            {
                this.Close();
            }
        }

        private void button_FilterPayment_Click(object sender, EventArgs e)
        {
            RefreshStatisticsList();
        }

        private void dataGridView1_SelectionChanged(object sender, EventArgs e)
        {
            dataGridView1.ClearSelection();
        }
    }
}
