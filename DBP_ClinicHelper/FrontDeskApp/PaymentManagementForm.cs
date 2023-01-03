using System;
using System.Data;
using System.Windows.Forms;

using ClinicHelper.Utils;

namespace ClinicHelper.FrontDeskApp
{
    public partial class PaymentManagementForm : Form
    {
        private DatabaseManager dbManager;
        private DataTable paymentInfoTable;

        public PaymentManagementForm()
        {
            InitializeComponent();
            dbManager = DatabaseManager.Instance;
        }

        private void TranslateColumnHeader()
        {
            dataGridView1.Columns["REGISTRATION_ID"].HeaderText = "접수 번호";
            dataGridView1.Columns["PATIENT_NAME"].HeaderText = "환자명";
            dataGridView1.Columns[2].HeaderText = "총 금액";
            dataGridView1.Columns["PAYMENT_DONE"].HeaderText = "수납 여부";
        }

        private void RefreshPaymentDataList()
        {
            int status = -1;
            if (radioButton_FilterByNotPaid.Checked)
                status = 0;
            else if (radioButton_FilterByPaid.Checked)
                status = 1;

            dbManager.FetchPaymentInfoTable(ref paymentInfoTable, status, dateTimePicker_Start.Value, dateTimePicker_End.Value);
            dataGridView1.DataSource = paymentInfoTable;
            TranslateColumnHeader();
        }

        private void EnableStatusEditor(bool enable)
        {
            radioButton_StatusNotPaid.Enabled = enable;
            radioButton_StatusPaid.Enabled = enable;
            button_SavePaymentStatus.Enabled = enable;
            if (!enable)
            {
                radioButton_StatusNotPaid.Checked = false;
                radioButton_StatusPaid.Checked = false;
            }
        }

        private void PaymentManagementForm_Load(object sender, EventArgs e)
        {
            RefreshPaymentDataList();
        }

        private void PaymentManagementForm_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Escape)
            {
                this.Close();
            }
        }

        private void button_FilterPayment_Click(object sender, EventArgs e)
        {
            RefreshPaymentDataList();
        }

        private void dataGridView1_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            DataRow row = paymentInfoTable.Rows[e.RowIndex];
            int status = Convert.ToInt32(row["payment_done"]);
            if (status == 0)
                radioButton_StatusNotPaid.Checked = true;
            else
                radioButton_StatusPaid.Checked = true;
            EnableStatusEditor(true);
        }

        private void button_SavePaymentStatus_Click(object sender, EventArgs e)
        {
            if (dataGridView1.SelectedRows.Count <= 0) return;
            DataRow row = paymentInfoTable.Rows[dataGridView1.SelectedRows[0].Index];
            int result = dbManager.UpdatePaymentStatus(Convert.ToInt32(row["registration_id"]), radioButton_StatusNotPaid.Checked ? 0 : 1);
            if (result > 0)
                MessageBox.Show("수납 상태가 수정되었습니다!", "수납 상태 변경", MessageBoxButtons.OK, MessageBoxIcon.Information);
            else
                MessageBox.Show("수납 상태를 수정하지 못했습니다!", "수납 상태 변경", MessageBoxButtons.OK, MessageBoxIcon.Error);
            button_FilterPayment.PerformClick();
        }
    }
}
