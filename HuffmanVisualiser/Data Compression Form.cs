using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace HuffmanVisualiser
{
    public partial class DataCompressionForm : Form
    {
        public DataCompressionForm()
        {
            InitializeComponent();
        }

        private void compressButton_Click(object sender, EventArgs e)
        {
            DLLManager.compress();
            MessageBox.Show("Compressed file successfully!");
        }

        private void decompressButton_Click(object sender, EventArgs e)
        {
            DLLManager.decompress();
            MessageBox.Show("Decompressed file successfully!");
        }

        private void visualiseButton_Click(object sender, EventArgs e)
        {
            HuffmanVisualiser hfv = new HuffmanVisualiser();
            hfv.Show();
        }
    }
}
