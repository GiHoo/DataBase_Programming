namespace ClinicHelper.FrontDeskApp.PatientManagement
{
    partial class PatientSearchForm
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
            this.label1 = new System.Windows.Forms.Label();
            this.dataGridView = new System.Windows.Forms.DataGridView();
            this.label2 = new System.Windows.Forms.Label();
            this.label13 = new System.Windows.Forms.Label();
            this.radioButton_SearchByID = new System.Windows.Forms.RadioButton();
            this.radioButton_SearchByName = new System.Windows.Forms.RadioButton();
            this.colorDialog1 = new System.Windows.Forms.ColorDialog();
            this.textBox_PatientID = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.textBox_PatientName = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.button_SearchPatient = new System.Windows.Forms.Button();
            this.radioButton_SearchAll = new System.Windows.Forms.RadioButton();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView)).BeginInit();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("굴림", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.label1.Location = new System.Drawing.Point(12, 14);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(96, 19);
            this.label1.TabIndex = 10;
            this.label1.Text = "환자 검색";
            // 
            // dataGridView
            // 
            this.dataGridView.AllowUserToAddRows = false;
            this.dataGridView.AllowUserToDeleteRows = false;
            this.dataGridView.AllowUserToResizeColumns = false;
            this.dataGridView.AllowUserToResizeRows = false;
            this.dataGridView.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dataGridView.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView.Location = new System.Drawing.Point(17, 45);
            this.dataGridView.MultiSelect = false;
            this.dataGridView.Name = "dataGridView";
            this.dataGridView.ReadOnly = true;
            this.dataGridView.RowHeadersVisible = false;
            this.dataGridView.RowTemplate.Height = 23;
            this.dataGridView.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dataGridView.Size = new System.Drawing.Size(824, 531);
            this.dataGridView.TabIndex = 11;
            this.dataGridView.CellDoubleClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dataGridView_CellDoubleClick);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("굴림", 14F);
            this.label2.Location = new System.Drawing.Point(871, 48);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(91, 19);
            this.label2.TabIndex = 10;
            this.label2.Text = "검색 조건";
            // 
            // label13
            // 
            this.label13.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label13.Location = new System.Drawing.Point(860, 41);
            this.label13.Name = "label13";
            this.label13.Size = new System.Drawing.Size(2, 540);
            this.label13.TabIndex = 12;
            // 
            // radioButton_SearchByID
            // 
            this.radioButton_SearchByID.AutoSize = true;
            this.radioButton_SearchByID.Font = new System.Drawing.Font("굴림", 12F);
            this.radioButton_SearchByID.Location = new System.Drawing.Point(876, 120);
            this.radioButton_SearchByID.Name = "radioButton_SearchByID";
            this.radioButton_SearchByID.Size = new System.Drawing.Size(147, 20);
            this.radioButton_SearchByID.TabIndex = 1;
            this.radioButton_SearchByID.Text = "환자 번호로 검색";
            this.radioButton_SearchByID.UseVisualStyleBackColor = true;
            this.radioButton_SearchByID.CheckedChanged += new System.EventHandler(this.radioButton_SearchByID_CheckedChanged);
            // 
            // radioButton_SearchByName
            // 
            this.radioButton_SearchByName.AutoSize = true;
            this.radioButton_SearchByName.Font = new System.Drawing.Font("굴림", 12F);
            this.radioButton_SearchByName.Location = new System.Drawing.Point(876, 189);
            this.radioButton_SearchByName.Name = "radioButton_SearchByName";
            this.radioButton_SearchByName.Size = new System.Drawing.Size(142, 20);
            this.radioButton_SearchByName.TabIndex = 3;
            this.radioButton_SearchByName.Text = "환자명으로 검색";
            this.radioButton_SearchByName.UseVisualStyleBackColor = true;
            this.radioButton_SearchByName.CheckedChanged += new System.EventHandler(this.radioButton_SearchByName_CheckedChanged);
            // 
            // textBox_PatientID
            // 
            this.textBox_PatientID.Enabled = false;
            this.textBox_PatientID.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientID.Location = new System.Drawing.Point(982, 148);
            this.textBox_PatientID.Name = "textBox_PatientID";
            this.textBox_PatientID.Size = new System.Drawing.Size(145, 26);
            this.textBox_PatientID.TabIndex = 2;
            this.textBox_PatientID.KeyUp += new System.Windows.Forms.KeyEventHandler(this.FilterTextBoxEnterEvent);
            // 
            // label3
            // 
            this.label3.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label3.Font = new System.Drawing.Font("굴림", 12F);
            this.label3.Location = new System.Drawing.Point(896, 148);
            this.label3.Name = "label3";
            this.label3.Padding = new System.Windows.Forms.Padding(3);
            this.label3.Size = new System.Drawing.Size(80, 26);
            this.label3.TabIndex = 14;
            this.label3.Text = "환자 ID";
            this.label3.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // textBox_PatientName
            // 
            this.textBox_PatientName.Enabled = false;
            this.textBox_PatientName.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientName.Location = new System.Drawing.Point(982, 217);
            this.textBox_PatientName.Name = "textBox_PatientName";
            this.textBox_PatientName.Size = new System.Drawing.Size(145, 26);
            this.textBox_PatientName.TabIndex = 4;
            this.textBox_PatientName.KeyUp += new System.Windows.Forms.KeyEventHandler(this.FilterTextBoxEnterEvent);
            // 
            // label4
            // 
            this.label4.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label4.Font = new System.Drawing.Font("굴림", 12F);
            this.label4.Location = new System.Drawing.Point(896, 217);
            this.label4.Name = "label4";
            this.label4.Padding = new System.Windows.Forms.Padding(3);
            this.label4.Size = new System.Drawing.Size(80, 26);
            this.label4.TabIndex = 24;
            this.label4.Text = "환자명";
            this.label4.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // button_SearchPatient
            // 
            this.button_SearchPatient.Font = new System.Drawing.Font("굴림", 14F);
            this.button_SearchPatient.Location = new System.Drawing.Point(1072, 251);
            this.button_SearchPatient.Name = "button_SearchPatient";
            this.button_SearchPatient.Size = new System.Drawing.Size(100, 32);
            this.button_SearchPatient.TabIndex = 5;
            this.button_SearchPatient.Text = "조건 반영";
            this.button_SearchPatient.UseVisualStyleBackColor = true;
            this.button_SearchPatient.Click += new System.EventHandler(this.button_SearchPatient_Click);
            // 
            // radioButton_SearchAll
            // 
            this.radioButton_SearchAll.AutoSize = true;
            this.radioButton_SearchAll.Checked = true;
            this.radioButton_SearchAll.Font = new System.Drawing.Font("굴림", 12F);
            this.radioButton_SearchAll.Location = new System.Drawing.Point(876, 84);
            this.radioButton_SearchAll.Name = "radioButton_SearchAll";
            this.radioButton_SearchAll.Size = new System.Drawing.Size(131, 20);
            this.radioButton_SearchAll.TabIndex = 0;
            this.radioButton_SearchAll.TabStop = true;
            this.radioButton_SearchAll.Text = "모든 환자 검색";
            this.radioButton_SearchAll.UseVisualStyleBackColor = true;
            this.radioButton_SearchAll.CheckedChanged += new System.EventHandler(this.radioButton_SearchByID_CheckedChanged);
            // 
            // PatientSearchForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1184, 593);
            this.Controls.Add(this.button_SearchPatient);
            this.Controls.Add(this.textBox_PatientName);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.textBox_PatientID);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.radioButton_SearchByName);
            this.Controls.Add(this.radioButton_SearchAll);
            this.Controls.Add(this.radioButton_SearchByID);
            this.Controls.Add(this.label13);
            this.Controls.Add(this.dataGridView);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.KeyPreview = true;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "PatientSearchForm";
            this.Text = "환자 조회";
            this.Load += new System.EventHandler(this.PatientSearchForm_Load);
            this.KeyUp += new System.Windows.Forms.KeyEventHandler(this.PatientSearchForm_KeyUp);
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.DataGridView dataGridView;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label13;
        private System.Windows.Forms.RadioButton radioButton_SearchByID;
        private System.Windows.Forms.RadioButton radioButton_SearchByName;
        private System.Windows.Forms.ColorDialog colorDialog1;
        private System.Windows.Forms.TextBox textBox_PatientID;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox textBox_PatientName;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Button button_SearchPatient;
        private System.Windows.Forms.RadioButton radioButton_SearchAll;
    }
}