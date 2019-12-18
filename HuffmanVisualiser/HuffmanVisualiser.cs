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
    public partial class HuffmanVisualiser : Form
    {
        List<HuffmanTree> huffmanTree;
        public HuffmanVisualiser()
        {
            InitTree();
            InitializeComponent();
        }

        private void InitTree()
        {
            HuffmanTree.SetRadius(25);
            huffmanTree = HuffmanTree.BuildTree("../../../Data Compression/Text Files/Huffman Tree.txt");

            huffmanTree[0].x = huffmanTree[0].y = 0;
            setPosition(false, 1, huffmanTree, huffmanTree[0].left, -1, 0);
            setPosition(true, 1, huffmanTree, huffmanTree[0].right, 1, 0);
        }

        private int setPosition(bool right, int level, List<HuffmanTree> huffmanTree, int idx, int prevX, int pivot)
        {
            if (idx == -1 || huffmanTree[idx].count == 0)
                return 0;

            HuffmanTree node = huffmanTree[idx];

            if(right)
            {
                prevX = setPosition(right, level + 1, huffmanTree, node.left, prevX - 1, pivot) + 1;
                if (prevX <= pivot)
                    prevX = pivot + 1;

                node.x = prevX;
                node.y = level;

                prevX = Math.Max(setPosition(right, level + 1, huffmanTree, node.right, prevX + 1, prevX), prevX);
            }
            else
            {
                prevX = setPosition(right, level + 1, huffmanTree, node.right, prevX + 1, pivot) - 1;
                if (prevX >= pivot)
                    prevX = pivot - 1;

                node.x = prevX;
                node.y = level;

                prevX = Math.Min(setPosition(right, level + 1, huffmanTree, node.left, prevX - 1, prevX), prevX);
            }

            return prevX;
        }

        private void VisualiserPanel_Paint(object sender, PaintEventArgs e)
        {
            Graphics g = e.Graphics;
            g.Clear(VisualiserPanel.BackColor);
            Pen p = new Pen(Color.DarkGray, 2);
            SolidBrush sb = new SolidBrush(Color.LightGray);
            SolidBrush brush = new SolidBrush(Color.Black);
            Font font = new Font(FontFamily.GenericMonospace, 10);


            int r = HuffmanTree.GetRadius();
            int d = r * 2;

            float xShift = r * 2 + Width * 0.00001f;
            float yShift = r * 2 + Width * 0.00001f;
            float yStart = d * 2;
            float xStart = Width / 2;

            for (int i = 0; i < huffmanTree.Count; i++)
            {
                HuffmanTree node = huffmanTree[i];

                if (node.count == 0) continue;

                float x = xStart + node.x * xShift;
                float y = yStart + node.y * yShift;
                float pxL = xStart + huffmanTree[node.left].x * xShift;
                float pyL = yStart + huffmanTree[node.left].y * yShift;
                float pxR = xStart + huffmanTree[node.right].x * xShift;
                float pyR = yStart + huffmanTree[node.right].y * yShift;

                if(huffmanTree[node.right].count != 0 || huffmanTree[node.left].count != 0)
                {
                    g.DrawLine(p, x - r, y - r, pxL - r, pyL - r);
                    g.DrawString("0", font, brush, (x - r + pxL - r) / 2,  (y - r + pyL - r) / 2);
                    g.DrawLine(p, x - r, y - r, pxR - r, pyR - r);
                    g.DrawString("1", font, brush, (x - r + pxR) / 2 - r, (y - r + pyR) / 2 - 10);
                }
                    g.DrawEllipse(p, x - d, y - d, d, d);
                    g.FillEllipse(sb, x - d, y - d, d, d);
                if(node.value.Equals(""))
                    g.DrawString(node.count.ToString(), font, brush, x - d + r / 2, y - r - r/4);
                else
                    g.DrawString(node.value + "(" + node.count + ")", font, brush, x - d + r / 4, y - r - r / 4);
            }
        }
    }
}
