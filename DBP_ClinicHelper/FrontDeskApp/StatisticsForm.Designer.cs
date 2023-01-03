namespace ClinicHelper.FrontDeskApp
{
    partial class StatisticsForm
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
            this.label6 = new System.Windows.Forms.Label();
            this.label12 = new System.Windows.Forms.Label();
            this.panel1 = new System.Windows.Forms.Panel();
            this.radioButton_ByDay = new System.Windows.Forms.RadioButton();
            this.radioButton_ByMonth = new System.Windows.Forms.RadioButton();
            this.radioButton_ByYear = new System.Windows.Forms.RadioButton();
            this.dataGridView1 = new System.Windows.Forms.DataGridView();
            this.button_FilterPayment = new System.Windows.Forms.Button();
            this.panel1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).BeginInit();
            this.SuspendLayout();
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Font = new System.Drawing.Font("굴림", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.label6.Location = new System.Drawing.Point(12, 14);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(96, 19);
            this.label6.TabIndex = 3;
            this.label6.Text = "종합 통계";
            // 
            // label12
            // 
            this.label12.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label12.Font = new System.Drawing.Font("굴림", 12F);
            this.label12.Location = new System.Drawing.Point(16, 44);
            this.label12.Name = "label12";
            this.label12.Padding = new System.Windows.Forms.Padding(3);
            this.label12.Size = new System.Drawing.Size(87, 26);
            this.label12.TabIndex = 32;
            this.label12.Text = "집계 기준";
            this.label12.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.radioButton_ByDay);
            this.panel1.Controls.Add(this.radioButton_ByMonth);
            this.panel1.Controls.Add(this.radioButton_ByYear);
            this.panel1.Font = new System.Drawing.Font("굴림", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.panel1.Location = new System.Drawing.Point(114, 44);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(191, 26);
            this.panel1.TabIndex = 0;
            // 
            // radioButton_ByDay
            // 
            this.radioButton_ByDay.AutoSize = true;
            this.radioButton_ByDay.Location = new System.Drawing.Point(147, 3);
            this.radioButton_ByDay.Name = "radioButton_ByDay";
            this.radioButton_ByDay.Size = new System.Drawing.Size(41, 20);
            this.radioButton_ByDay.TabIndex = 2;
            this.radioButton_ByDay.Text = "일";
            this.radioButton_ByDay.UseVisualStyleBackColor = true;
            // 
            // radioButton_ByMonth
            // 
            this.radioButton_ByMonth.AutoSize = true;
            this.radioButton_ByMonth.Location = new System.Drawing.Point(83, 3);
            this.radioButton_ByMonth.Name = "radioButton_ByMonth";
            this.radioButton_ByMonth.Size = new System.Drawing.Size(41, 20);
            this.radioButton_ByMonth.TabIndex = 1;
            this.radioButton_ByMonth.Text = "월";
            this.radioButton_ByMonth.UseVisualStyleBackColor = true;
            // 
            // radioButton_ByYear
            // 
            this.radioButton_ByYear.AutoSize = true;
            this.radioButton_ByYear.Checked = true;
            this.radioButton_ByYear.Location = new System.Drawing.Point(3, 3);
            this.radioButton_ByYear.Name = "radioButton_ByYear";
            this.radioButton_ByYear.Size = new System.Drawing.Size(57, 20);
            this.radioButton_ByYear.TabIndex = 0;
            this.radioButton_ByYear.TabStop = true;
            this.radioButton_ByYear.Text = "연도";
            this.radioButton_ByYear.UseVisualStyleBackColor = true;
            // 
            // dataGridView1
            // 
            this.dataGridView1.AllowUserToAddRows = false;
            this.dataGridView1.AllowUserToDeleteRows = false;
            this.dataGridView1.AllowUserToResizeColumns = false;
            this.dataGridView1.AllowUserToResizeRows = false;
            this.dataGridView1.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dataGridView1.AutoSizeRowsMode = System.Windows.Forms.DataGridViewAutoSizeRowsMode.DisplayedCells;
            this.dataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView1.Location = new System.Drawing.Point(16, 76);
            this.dataGridView1.MultiSelect = false;
            this.dataGridView1.Name = "dataGridView1";
            this.dataGridView1.ReadOnly = true;
            this.dataGridView1.RowHeadersVisible = false;
            this.dataGridView1.RowTemplate.Height = 23;
            this.dataGridView1.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dataGridView1.Size = new System.Drawing.Size(574, 467);
            this.dataGridView1.TabIndex = 2;
            this.dataGridView1.SelectionChanged += new System.EventHandler(this.dataGridView1_SelectionChanged);
            // 
            // button_FilterPayment
            // 
            this.button_FilterPayment.Font = new System.Drawing.Font("굴림", 12F);
            this.button_FilterPayment.Location = new System.Drawing.Point(311, 44);
            this.button_FilterPayment.Name = "button_FilterPayment";
            this.button_FilterPayment.Size = new System.Drawing.Size(94, 26);
            this.button_FilterPayment.TabIndex = 1;
            this.button_FilterPayment.Text = "조건 반영";
            this.button_FilterPayment.UseVisualStyleBackColor = true;
            this.button_FilterPayment.Click += new System.EventHandler(this.button_FilterPayment_Click);
            // 
            // StatisticsForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(606, 559);
            this.Controls.Add(this.button_FilterPayment);
            this.Controls.Add(this.dataGridView1);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.label12);
            this.Controls.Add(this.label6);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.KeyPreview = true;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "StatisticsForm";
            this.Text = "통계 조회";
            this.Load += new System.EventHandler(this.StatisticsForm_Load);
            this.KeyUp += new System.Windows.Forms.KeyEventHandler(this.StatisticsForm_KeyUp);
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label label12;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.RadioButton radioButton_ByDay;
        private System.Windows.Forms.RadioButton radioButton_ByMonth;
        private System.Windows.Forms.RadioButton radioButton_ByYear;
        private System.Windows.Forms.DataGridView dataGridView1;
        private System.Windows.Forms.Button button_FilterPayment;
    }
}