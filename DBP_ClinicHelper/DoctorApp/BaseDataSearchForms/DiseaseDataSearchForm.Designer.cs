namespace ClinicHelper.DoctorApp.BaseDataSearchForms
{
    partial class DiseaseDataSearchForm
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
            this.label9 = new System.Windows.Forms.Label();
            this.label11 = new System.Windows.Forms.Label();
            this.textBox_FilterKCDCode = new System.Windows.Forms.TextBox();
            this.label12 = new System.Windows.Forms.Label();
            this.textBox_FilterDiseaseName = new System.Windows.Forms.TextBox();
            this.button_ApplyFilter = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).BeginInit();
            this.SuspendLayout();
            // 
            // dataGridView1
            // 
            this.dataGridView1.AllowUserToAddRows = false;
            this.dataGridView1.AllowUserToDeleteRows = false;
            this.dataGridView1.AllowUserToResizeColumns = false;
            this.dataGridView1.AllowUserToResizeRows = false;
            this.dataGridView1.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView1.Location = new System.Drawing.Point(12, 43);
            this.dataGridView1.Name = "dataGridView1";
            this.dataGridView1.ReadOnly = true;
            this.dataGridView1.RowHeadersVisible = false;
            this.dataGridView1.RowTemplate.Height = 23;
            this.dataGridView1.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dataGridView1.Size = new System.Drawing.Size(381, 381);
            this.dataGridView1.TabIndex = 0;
            this.dataGridView1.CellDoubleClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dataGridView1_CellDoubleClick);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("굴림", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.label1.Location = new System.Drawing.Point(8, 11);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(143, 19);
            this.label1.TabIndex = 10;
            this.label1.Text = "질병 코드 검색";
            // 
            // label13
            // 
            this.label13.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label13.Location = new System.Drawing.Point(404, 38);
            this.label13.Name = "label13";
            this.label13.Size = new System.Drawing.Size(2, 395);
            this.label13.TabIndex = 11;
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Font = new System.Drawing.Font("굴림", 14F);
            this.label9.Location = new System.Drawing.Point(412, 43);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(91, 19);
            this.label9.TabIndex = 1;
            this.label9.Text = "검색 조건";
            // 
            // label11
            // 
            this.label11.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label11.Font = new System.Drawing.Font("굴림", 12F);
            this.label11.Location = new System.Drawing.Point(415, 72);
            this.label11.Name = "label11";
            this.label11.Padding = new System.Windows.Forms.Padding(3);
            this.label11.Size = new System.Drawing.Size(83, 26);
            this.label11.TabIndex = 2;
            this.label11.Text = "KCD 코드";
            this.label11.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // textBox_FilterKCDCode
            // 
            this.textBox_FilterKCDCode.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_FilterKCDCode.Location = new System.Drawing.Point(504, 72);
            this.textBox_FilterKCDCode.Name = "textBox_FilterKCDCode";
            this.textBox_FilterKCDCode.Size = new System.Drawing.Size(87, 26);
            this.textBox_FilterKCDCode.TabIndex = 0;
            this.textBox_FilterKCDCode.KeyUp += new System.Windows.Forms.KeyEventHandler(this.EditorCommonKeyUpHandler);
            // 
            // label12
            // 
            this.label12.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label12.Font = new System.Drawing.Font("굴림", 12F);
            this.label12.Location = new System.Drawing.Point(415, 104);
            this.label12.Name = "label12";
            this.label12.Padding = new System.Windows.Forms.Padding(3);
            this.label12.Size = new System.Drawing.Size(83, 26);
            this.label12.TabIndex = 12;
            this.label12.Text = "질병명";
            this.label12.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // textBox_FilterDiseaseName
            // 
            this.textBox_FilterDiseaseName.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_FilterDiseaseName.Location = new System.Drawing.Point(504, 104);
            this.textBox_FilterDiseaseName.Name = "textBox_FilterDiseaseName";
            this.textBox_FilterDiseaseName.Size = new System.Drawing.Size(226, 26);
            this.textBox_FilterDiseaseName.TabIndex = 1;
            this.textBox_FilterDiseaseName.KeyUp += new System.Windows.Forms.KeyEventHandler(this.EditorCommonKeyUpHandler);
            // 
            // button_ApplyFilter
            // 
            this.button_ApplyFilter.Font = new System.Drawing.Font("굴림", 14F);
            this.button_ApplyFilter.Location = new System.Drawing.Point(630, 136);
            this.button_ApplyFilter.Name = "button_ApplyFilter";
            this.button_ApplyFilter.Size = new System.Drawing.Size(100, 32);
            this.button_ApplyFilter.TabIndex = 2;
            this.button_ApplyFilter.Text = "조건 반영";
            this.button_ApplyFilter.UseVisualStyleBackColor = true;
            this.button_ApplyFilter.Click += new System.EventHandler(this.button_ApplyFilter_Click);
            // 
            // DiseaseDataSearchForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(744, 441);
            this.Controls.Add(this.button_ApplyFilter);
            this.Controls.Add(this.textBox_FilterDiseaseName);
            this.Controls.Add(this.label12);
            this.Controls.Add(this.textBox_FilterKCDCode);
            this.Controls.Add(this.label11);
            this.Controls.Add(this.label13);
            this.Controls.Add(this.label9);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.dataGridView1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.KeyPreview = true;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "DiseaseDataSearchForm";
            this.Load += new System.EventHandler(this.DiseaseDataManagementForm_Load);
            this.KeyUp += new System.Windows.Forms.KeyEventHandler(this.DiseaseDataManagementForm_KeyUp);
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.DataGridView dataGridView1;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label13;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.Label label11;
        private System.Windows.Forms.TextBox textBox_FilterKCDCode;
        private System.Windows.Forms.Label label12;
        private System.Windows.Forms.TextBox textBox_FilterDiseaseName;
        private System.Windows.Forms.Button button_ApplyFilter;
    }
}