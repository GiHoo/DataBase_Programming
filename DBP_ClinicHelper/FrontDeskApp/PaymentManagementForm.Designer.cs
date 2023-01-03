namespace ClinicHelper.FrontDeskApp
{
    partial class PaymentManagementForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.dataGridView1 = new System.Windows.Forms.DataGridView();
            this.label1 = new System.Windows.Forms.Label();
            this.label13 = new System.Windows.Forms.Label();
            this.label14 = new System.Windows.Forms.Label();
            this.radioButton_FilterByNotPaid = new System.Windows.Forms.RadioButton();
            this.radioButton_FilterByPaid = new System.Windows.Forms.RadioButton();
            this.button_FilterPayment = new System.Windows.Forms.Button();
            this.labelDivider1 = new System.Windows.Forms.Label();
            this.panel1 = new System.Windows.Forms.Panel();
            this.radioButton_FilterByNothing = new System.Windows.Forms.RadioButton();
            this.panel2 = new System.Windows.Forms.Panel();
            this.radioButton_StatusNotPaid = new System.Windows.Forms.RadioButton();
            this.radioButton_StatusPaid = new System.Windows.Forms.RadioButton();
            this.label2 = new System.Windows.Forms.Label();
            this.button_SavePaymentStatus = new System.Windows.Forms.Button();
            this.dateTimePicker_Start = new System.Windows.Forms.DateTimePicker();
            this.label12 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.dateTimePicker_End = new System.Windows.Forms.DateTimePicker();
            this.label4 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).BeginInit();
            this.panel1.SuspendLayout();
            this.panel2.SuspendLayout();
            this.SuspendLayout();
            // 
            // dataGridView1
            // 
            this.dataGridView1.AllowUserToAddRows = false;
            this.dataGridView1.AllowUserToDeleteRows = false;
            this.dataGridView1.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView1.Location = new System.Drawing.Point(16, 50);
            this.dataGridView1.MultiSelect = false;
            this.dataGridView1.Name = "dataGridView1";
            this.dataGridView1.ReadOnly = true;
            this.dataGridView1.RowHeadersVisible = false;
            this.dataGridView1.RowTemplate.Height = 23;
            this.dataGridView1.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dataGridView1.Size = new System.Drawing.Size(444, 441);
            this.dataGridView1.TabIndex = 0;
            this.dataGridView1.CellClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dataGridView1_CellClick);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("굴림", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.label1.Location = new System.Drawing.Point(12, 14);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(96, 19);
            this.label1.TabIndex = 11;
            this.label1.Text = "수납 관리";
            // 
            // label13
            // 
            this.label13.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label13.Location = new System.Drawing.Point(472, 39);
            this.label13.Name = "label13";
            this.label13.Size = new System.Drawing.Size(2, 465);
            this.label13.TabIndex = 13;
            // 
            // label14
            // 
            this.label14.AutoSize = true;
            this.label14.Font = new System.Drawing.Font("굴림", 14F);
            this.label14.Location = new System.Drawing.Point(482, 50);
            this.label14.Name = "label14";
            this.label14.Size = new System.Drawing.Size(91, 19);
            this.label14.TabIndex = 14;
            this.label14.Text = "검색 조건";
            // 
            // radioButton_FilterByNotPaid
            // 
            this.radioButton_FilterByNotPaid.AutoSize = true;
            this.radioButton_FilterByNotPaid.Font = new System.Drawing.Font("굴림", 12F);
            this.radioButton_FilterByNotPaid.Location = new System.Drawing.Point(14, 33);
            this.radioButton_FilterByNotPaid.Name = "radioButton_FilterByNotPaid";
            this.radioButton_FilterByNotPaid.Size = new System.Drawing.Size(73, 20);
            this.radioButton_FilterByNotPaid.TabIndex = 1;
            this.radioButton_FilterByNotPaid.Text = "미수납";
            this.radioButton_FilterByNotPaid.UseVisualStyleBackColor = true;
            // 
            // radioButton_FilterByPaid
            // 
            this.radioButton_FilterByPaid.AutoSize = true;
            this.radioButton_FilterByPaid.Font = new System.Drawing.Font("굴림", 12F);
            this.radioButton_FilterByPaid.Location = new System.Drawing.Point(14, 60);
            this.radioButton_FilterByPaid.Name = "radioButton_FilterByPaid";
            this.radioButton_FilterByPaid.Size = new System.Drawing.Size(94, 20);
            this.radioButton_FilterByPaid.TabIndex = 2;
            this.radioButton_FilterByPaid.Text = "수납 완료";
            this.radioButton_FilterByPaid.UseVisualStyleBackColor = true;
            // 
            // button_FilterPayment
            // 
            this.button_FilterPayment.Font = new System.Drawing.Font("굴림", 14F);
            this.button_FilterPayment.Location = new System.Drawing.Point(601, 302);
            this.button_FilterPayment.Name = "button_FilterPayment";
            this.button_FilterPayment.Size = new System.Drawing.Size(100, 32);
            this.button_FilterPayment.TabIndex = 3;
            this.button_FilterPayment.Text = "조건 반영";
            this.button_FilterPayment.UseVisualStyleBackColor = true;
            this.button_FilterPayment.Click += new System.EventHandler(this.button_FilterPayment_Click);
            // 
            // labelDivider1
            // 
            this.labelDivider1.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.labelDivider1.Location = new System.Drawing.Point(483, 343);
            this.labelDivider1.Name = "labelDivider1";
            this.labelDivider1.Size = new System.Drawing.Size(230, 2);
            this.labelDivider1.TabIndex = 28;
            // 
            // panel1
            // 
            this.panel1.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
            this.panel1.Controls.Add(this.radioButton_FilterByNothing);
            this.panel1.Controls.Add(this.radioButton_FilterByNotPaid);
            this.panel1.Controls.Add(this.radioButton_FilterByPaid);
            this.panel1.Location = new System.Drawing.Point(584, 79);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(117, 84);
            this.panel1.TabIndex = 0;
            // 
            // radioButton_FilterByNothing
            // 
            this.radioButton_FilterByNothing.AutoSize = true;
            this.radioButton_FilterByNothing.Checked = true;
            this.radioButton_FilterByNothing.Font = new System.Drawing.Font("굴림", 12F);
            this.radioButton_FilterByNothing.Location = new System.Drawing.Point(14, 6);
            this.radioButton_FilterByNothing.Name = "radioButton_FilterByNothing";
            this.radioButton_FilterByNothing.Size = new System.Drawing.Size(57, 20);
            this.radioButton_FilterByNothing.TabIndex = 0;
            this.radioButton_FilterByNothing.TabStop = true;
            this.radioButton_FilterByNothing.Text = "전체";
            this.radioButton_FilterByNothing.UseVisualStyleBackColor = true;
            // 
            // panel2
            // 
            this.panel2.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
            this.panel2.Controls.Add(this.radioButton_StatusNotPaid);
            this.panel2.Controls.Add(this.radioButton_StatusPaid);
            this.panel2.Location = new System.Drawing.Point(584, 383);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(117, 55);
            this.panel2.TabIndex = 4;
            // 
            // radioButton_StatusNotPaid
            // 
            this.radioButton_StatusNotPaid.AutoSize = true;
            this.radioButton_StatusNotPaid.Enabled = false;
            this.radioButton_StatusNotPaid.Font = new System.Drawing.Font("굴림", 12F);
            this.radioButton_StatusNotPaid.Location = new System.Drawing.Point(14, 4);
            this.radioButton_StatusNotPaid.Name = "radioButton_StatusNotPaid";
            this.radioButton_StatusNotPaid.Size = new System.Drawing.Size(73, 20);
            this.radioButton_StatusNotPaid.TabIndex = 0;
            this.radioButton_StatusNotPaid.TabStop = true;
            this.radioButton_StatusNotPaid.Text = "미수납";
            this.radioButton_StatusNotPaid.UseVisualStyleBackColor = true;
            // 
            // radioButton_StatusPaid
            // 
            this.radioButton_StatusPaid.AutoSize = true;
            this.radioButton_StatusPaid.Enabled = false;
            this.radioButton_StatusPaid.Font = new System.Drawing.Font("굴림", 12F);
            this.radioButton_StatusPaid.Location = new System.Drawing.Point(14, 31);
            this.radioButton_StatusPaid.Name = "radioButton_StatusPaid";
            this.radioButton_StatusPaid.Size = new System.Drawing.Size(94, 20);
            this.radioButton_StatusPaid.TabIndex = 1;
            this.radioButton_StatusPaid.TabStop = true;
            this.radioButton_StatusPaid.Text = "수납 완료";
            this.radioButton_StatusPaid.UseVisualStyleBackColor = true;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("굴림", 14F);
            this.label2.Location = new System.Drawing.Point(482, 354);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(135, 19);
            this.label2.TabIndex = 14;
            this.label2.Text = "수납 상태 변경";
            // 
            // button_SavePaymentStatus
            // 
            this.button_SavePaymentStatus.Enabled = false;
            this.button_SavePaymentStatus.Font = new System.Drawing.Font("굴림", 14F);
            this.button_SavePaymentStatus.Location = new System.Drawing.Point(603, 444);
            this.button_SavePaymentStatus.Name = "button_SavePaymentStatus";
            this.button_SavePaymentStatus.Size = new System.Drawing.Size(100, 32);
            this.button_SavePaymentStatus.TabIndex = 5;
            this.button_SavePaymentStatus.Text = "상태 변경";
            this.button_SavePaymentStatus.UseVisualStyleBackColor = true;
            this.button_SavePaymentStatus.Click += new System.EventHandler(this.button_SavePaymentStatus_Click);
            // 
            // dateTimePicker_Start
            // 
            this.dateTimePicker_Start.Location = new System.Drawing.Point(486, 209);
            this.dateTimePicker_Start.Name = "dateTimePicker_Start";
            this.dateTimePicker_Start.Size = new System.Drawing.Size(215, 21);
            this.dateTimePicker_Start.TabIndex = 1;
            // 
            // label12
            // 
            this.label12.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label12.Font = new System.Drawing.Font("굴림", 12F);
            this.label12.Location = new System.Drawing.Point(486, 80);
            this.label12.Name = "label12";
            this.label12.Padding = new System.Windows.Forms.Padding(3);
            this.label12.Size = new System.Drawing.Size(83, 26);
            this.label12.TabIndex = 31;
            this.label12.Text = "수납상태";
            this.label12.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // label3
            // 
            this.label3.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label3.Font = new System.Drawing.Font("굴림", 12F);
            this.label3.Location = new System.Drawing.Point(486, 177);
            this.label3.Name = "label3";
            this.label3.Padding = new System.Windows.Forms.Padding(3);
            this.label3.Size = new System.Drawing.Size(97, 26);
            this.label3.TabIndex = 31;
            this.label3.Text = "시작 기간";
            this.label3.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // dateTimePicker_End
            // 
            this.dateTimePicker_End.Location = new System.Drawing.Point(486, 275);
            this.dateTimePicker_End.Name = "dateTimePicker_End";
            this.dateTimePicker_End.Size = new System.Drawing.Size(215, 21);
            this.dateTimePicker_End.TabIndex = 2;
            // 
            // label4
            // 
            this.label4.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label4.Font = new System.Drawing.Font("굴림", 12F);
            this.label4.Location = new System.Drawing.Point(486, 243);
            this.label4.Name = "label4";
            this.label4.Padding = new System.Windows.Forms.Padding(3);
            this.label4.Size = new System.Drawing.Size(97, 26);
            this.label4.TabIndex = 31;
            this.label4.Text = "종료 기간";
            this.label4.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // label5
            // 
            this.label5.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label5.Font = new System.Drawing.Font("굴림", 12F);
            this.label5.Location = new System.Drawing.Point(486, 384);
            this.label5.Name = "label5";
            this.label5.Padding = new System.Windows.Forms.Padding(3);
            this.label5.Size = new System.Drawing.Size(83, 26);
            this.label5.TabIndex = 31;
            this.label5.Text = "수납상태";
            this.label5.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // PaymentManagementForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(715, 516);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.dateTimePicker_End);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.label12);
            this.Controls.Add(this.dateTimePicker_Start);
            this.Controls.Add(this.labelDivider1);
            this.Controls.Add(this.button_SavePaymentStatus);
            this.Controls.Add(this.button_FilterPayment);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label14);
            this.Controls.Add(this.label13);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.panel2);
            this.Controls.Add(this.dataGridView1);
            this.Controls.Add(this.panel1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.KeyPreview = true;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "PaymentManagementForm";
            this.Text = "수납 관리";
            this.Load += new System.EventHandler(this.PaymentManagementForm_Load);
            this.KeyUp += new System.Windows.Forms.KeyEventHandler(this.PaymentManagementForm_KeyUp);
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).EndInit();
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.panel2.ResumeLayout(false);
            this.panel2.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.DataGridView dataGridView1;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label13;
        private System.Windows.Forms.Label label14;
        private System.Windows.Forms.RadioButton radioButton_FilterByNotPaid;
        private System.Windows.Forms.RadioButton radioButton_FilterByPaid;
        private System.Windows.Forms.Button button_FilterPayment;
        private System.Windows.Forms.Label labelDivider1;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.RadioButton radioButton_FilterByNothing;
        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.RadioButton radioButton_StatusNotPaid;
        private System.Windows.Forms.RadioButton radioButton_StatusPaid;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button button_SavePaymentStatus;
        private System.Windows.Forms.DateTimePicker dateTimePicker_Start;
        private System.Windows.Forms.Label label12;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.DateTimePicker dateTimePicker_End;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label5;
    }
}