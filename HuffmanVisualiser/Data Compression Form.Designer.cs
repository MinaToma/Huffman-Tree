namespace HuffmanVisualiser
{
    partial class DataCompressionForm
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
            this.visualiseButton = new System.Windows.Forms.Button();
            this.compressButton = new System.Windows.Forms.Button();
            this.decompressButton = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // visualiseButton
            // 
            this.visualiseButton.BackColor = System.Drawing.Color.Khaki;
            this.visualiseButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.visualiseButton.Font = new System.Drawing.Font("Bebas Neue", 16.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.visualiseButton.Image = global::HuffmanVisualiser.Properties.Resources.visualise_icon;
            this.visualiseButton.Location = new System.Drawing.Point(388, -5);
            this.visualiseButton.Name = "visualiseButton";
            this.visualiseButton.Size = new System.Drawing.Size(400, 460);
            this.visualiseButton.TabIndex = 2;
            this.visualiseButton.UseVisualStyleBackColor = false;
            this.visualiseButton.Click += new System.EventHandler(this.visualiseButton_Click);
            // 
            // compressButton
            // 
            this.compressButton.BackColor = System.Drawing.Color.Chocolate;
            this.compressButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.compressButton.Font = new System.Drawing.Font("Bebas Neue", 16.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.compressButton.Image = global::HuffmanVisualiser.Properties.Resources.compress_icon;
            this.compressButton.Location = new System.Drawing.Point(-4, -5);
            this.compressButton.Name = "compressButton";
            this.compressButton.Size = new System.Drawing.Size(400, 460);
            this.compressButton.TabIndex = 1;
            this.compressButton.UseVisualStyleBackColor = false;
            this.compressButton.Click += new System.EventHandler(this.compressButton_Click);
            // 
            // decompressButton
            // 
            this.decompressButton.BackColor = System.Drawing.Color.MediumSeaGreen;
            this.decompressButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.decompressButton.Font = new System.Drawing.Font("Bebas Neue", 16.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.decompressButton.Image = global::HuffmanVisualiser.Properties.Resources.decompress_icon;
            this.decompressButton.Location = new System.Drawing.Point(785, -5);
            this.decompressButton.Name = "decompressButton";
            this.decompressButton.Size = new System.Drawing.Size(400, 460);
            this.decompressButton.TabIndex = 0;
            this.decompressButton.UseVisualStyleBackColor = false;
            this.decompressButton.Click += new System.EventHandler(this.decompressButton_Click);
            // 
            // DataCompressionForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1182, 453);
            this.Controls.Add(this.visualiseButton);
            this.Controls.Add(this.compressButton);
            this.Controls.Add(this.decompressButton);
            this.Name = "DataCompressionForm";
            this.Text = "Data Compression";
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button decompressButton;
        private System.Windows.Forms.Button compressButton;
        private System.Windows.Forms.Button visualiseButton;
    }
}