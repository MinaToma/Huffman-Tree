namespace HuffmanVisualiser
{
    partial class HuffmanVisualiser
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
            this.VisualiserPanel = new System.Windows.Forms.Panel();
            this.SuspendLayout();
            // 
            // VisualiserPanel
            // 
            this.VisualiserPanel.AutoScroll = true;
            this.VisualiserPanel.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.VisualiserPanel.Dock = System.Windows.Forms.DockStyle.Fill;
            this.VisualiserPanel.Location = new System.Drawing.Point(0, 0);
            this.VisualiserPanel.Name = "VisualiserPanel";
            this.VisualiserPanel.Size = new System.Drawing.Size(1503, 673);
            this.VisualiserPanel.TabIndex = 1;
            this.VisualiserPanel.Paint += new System.Windows.Forms.PaintEventHandler(this.VisualiserPanel_Paint);
            // 
            // HuffmanVisualiser
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoScroll = true;
            this.ClientSize = new System.Drawing.Size(1503, 673);
            this.Controls.Add(this.VisualiserPanel);
            this.DoubleBuffered = true;
            this.Name = "HuffmanVisualiser";
            this.Text = "HuffmanVisualiser";
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel VisualiserPanel;
    }
}