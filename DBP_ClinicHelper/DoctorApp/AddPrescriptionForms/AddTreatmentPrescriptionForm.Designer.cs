namespace ClinicHelper.DoctorApp
{
    partial class AddTreatmentPrescriptionForm
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
            this.button_SearchTreatment = new System.Windows.Forms.Button();
            this.button_SaveTreatment = new System.Windows.Forms.Button();
            this.textBox_TotalCount = new System.Windows.Forms.TextBox();
            this.textBox_Name = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.label12 = new System.Windows.Forms.Label();
            this.textBox_Code = new System.Windows.Forms.TextBox();
            this.label11 = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // button_SearchTreatment
            // 
            this.button_SearchTreatment.Font = new System.Drawing.Font("굴림", 12F);
            this.button_SearchTreatment.Location = new System.Drawing.Point(209, 47);
            this.button_SearchTreatment.Name = "button_SearchTreatment";
            this.button_SearchTreatment.Size = new System.Drawing.Size(113, 26);
            this.button_SearchTreatment.TabIndex = 1;
            this.button_SearchTreatment.Text = "행위 검색";
            this.button_SearchTreatment.UseVisualStyleBackColor = true;
            this.button_SearchTreatment.Click += new System.EventHandler(this.button_SearchTreatment_Click);
            // 
            // button_SaveTreatment
            // 
            this.button_SaveTreatment.Font = new System.Drawing.Font("굴림", 12F);
            this.button_SaveTreatment.Location = new System.Drawing.Point(15, 143);
            this.button_SaveTreatment.Name = "button_SaveTreatment";
            this.button_SaveTreatment.Size = new System.Drawing.Size(306, 23);
            this.button_SaveTreatment.TabIndex = 4;
            this.button_SaveTreatment.Text = "행위 추가";
            this.button_SaveTreatment.UseVisualStyleBackColor = true;
            this.button_SaveTreatment.Click += new System.EventHandler(this.button_SaveTreatment_Click);
            // 
            // textBox_TotalCount
            // 
            this.textBox_TotalCount.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_TotalCount.Location = new System.Drawing.Point(121, 111);
            this.textBox_TotalCount.Name = "textBox_TotalCount";
            this.textBox_TotalCount.Size = new System.Drawing.Size(51, 26);
            this.textBox_TotalCount.TabIndex = 3;
            // 
            // textBox_Name
            // 
            this.textBox_Name.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_Name.Location = new System.Drawing.Point(104, 79);
            this.textBox_Name.Name = "textBox_Name";
            this.textBox_Name.ReadOnly = true;
            this.textBox_Name.Size = new System.Drawing.Size(218, 26);
            this.textBox_Name.TabIndex = 2;
            // 
            // label2
            // 
            this.label2.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label2.Font = new System.Drawing.Font("굴림", 12F);
            this.label2.Location = new System.Drawing.Point(15, 111);
            this.label2.Name = "label2";
            this.label2.Padding = new System.Windows.Forms.Padding(3);
            this.label2.Size = new System.Drawing.Size(100, 26);
            this.label2.TabIndex = 34;
            this.label2.Text = "총 행위 수";
            this.label2.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // label12
            // 
            this.label12.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label12.Font = new System.Drawing.Font("굴림", 12F);
            this.label12.Location = new System.Drawing.Point(15, 79);
            this.label12.Name = "label12";
            this.label12.Padding = new System.Windows.Forms.Padding(3);
            this.label12.Size = new System.Drawing.Size(83, 26);
            this.label12.TabIndex = 35;
            this.label12.Text = "행위명";
            this.label12.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // textBox_Code
            // 
            this.textBox_Code.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_Code.Location = new System.Drawing.Point(104, 47);
            this.textBox_Code.Name = "textBox_Code";
            this.textBox_Code.Size = new System.Drawing.Size(99, 26);
            this.textBox_Code.TabIndex = 0;
            // 
            // label11
            // 
            this.label11.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label11.Font = new System.Drawing.Font("굴림", 12F);
            this.label11.Location = new System.Drawing.Point(15, 47);
            this.label11.Name = "label11";
            this.label11.Padding = new System.Windows.Forms.Padding(3);
            this.label11.Size = new System.Drawing.Size(83, 26);
            this.label11.TabIndex = 36;
            this.label11.Text = "행위코드";
            this.label11.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("굴림", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.label1.Location = new System.Drawing.Point(12, 14);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(190, 19);
            this.label1.TabIndex = 31;
            this.label1.Text = "의료 행위 처방 추가";
            // 
            // AddTreatmentPrescriptionForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(336, 178);
            this.Controls.Add(this.button_SearchTreatment);
            this.Controls.Add(this.button_SaveTreatment);
            this.Controls.Add(this.textBox_TotalCount);
            this.Controls.Add(this.textBox_Name);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label12);
            this.Controls.Add(this.textBox_Code);
            this.Controls.Add(this.label11);
            this.Controls.Add(this.label1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.KeyPreview = true;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "AddTreatmentPrescriptionForm";
            this.Text = "의료 행위 처방 추가";
            this.KeyUp += new System.Windows.Forms.KeyEventHandler(this.AddTreatmentPrescriptionForm_KeyUp);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button button_SearchTreatment;
        private System.Windows.Forms.Button button_SaveTreatment;
        private System.Windows.Forms.TextBox textBox_TotalCount;
        private System.Windows.Forms.TextBox textBox_Name;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label12;
        private System.Windows.Forms.TextBox textBox_Code;
        private System.Windows.Forms.Label label11;
        private System.Windows.Forms.Label label1;
    }
}