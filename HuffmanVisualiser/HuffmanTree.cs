using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace HuffmanVisualiser
{
    class HuffmanTree
    {
        public string value;
        public int count, left, right;
        public float x;
        public float y;


        private static int _radius = 35;


        public HuffmanTree(string value, int count)
        {
            left = right = -1;
            this.value = value;
            this.count = count;
        }

        public static void SetRadius(int radius)
        {
            _radius = radius;
        }

        public static int GetRadius()
        {
            return _radius;
        }

        public string GetValue()
        {
            return value;
        }

        public void SetValue(string value)
        {
            this.value = value;
        }


        public static List<HuffmanTree> BuildTree(string file)
        {
            return BuildTree(file, _radius);
        }
        public static List<HuffmanTree> BuildTree(string file, int radius)
        {
            List<HuffmanTree> huffmanTree = new List<HuffmanTree>();

            FileStream fs = new FileStream(file, FileMode.OpenOrCreate);
            StreamReader sr = new StreamReader(fs);

            string count = sr.ReadLine();
            string[] countArray = count.Split(' ');

            if (countArray[countArray.Length - 1].Equals(""))
                countArray = countArray.Take(countArray.Length - 1).ToArray();

            string values = sr.ReadLine();
            string[] valuesArray = values.Split(' ');

            if (valuesArray[valuesArray.Length - 1].Equals(""))
                valuesArray = valuesArray.Take(valuesArray.Length - 1).ToArray();

            HuffmanTree node;
            node = new HuffmanTree("", int.Parse(countArray[0]));
            huffmanTree.Add(node);

            for (int i = 1, j = 0, cur = 0; i < countArray.Length; i+=2, cur++)
            {
                if(huffmanTree[cur].count == 0)
                {
                    i -= 2;
                    continue;
                }

                HuffmanTree nodeF;
                HuffmanTree nodeS;
                nodeF = new HuffmanTree("", int.Parse(countArray[i]));
                nodeS = new HuffmanTree("", int.Parse(countArray[i + 1]));

                huffmanTree[cur].left = i;
                huffmanTree[cur].right = i + 1;
                
                huffmanTree.Add(nodeF);
                huffmanTree.Add(nodeS);

                if (countArray[i].Equals("0"))
                {
                    node = huffmanTree.ElementAt(cur);
                    node.SetValue(valuesArray[j++]);
                }
            }

            sr.Close();
            fs.Close();

            return huffmanTree;
        }

    }
}
