#!/bin/bash

# Check if an argument (CSV file) is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <input_file.csv>"
  exit 1
fi

# Input CSV file
input_file="$1"
output_file="table_output.tex"

# Write the beginning of the LaTeX document
echo "\\documentclass{article}" > $output_file
echo "\\usepackage{booktabs}" >> $output_file
echo "\\usepackage{graphicx}" >> $output_file
echo "\\usepackage{longtable}" >> $output_file  # Use longtable for better page handling
echo "\\begin{document}" >> $output_file

# Start the center environment to center the table
echo "\\begin{center}" >> $output_file

# Start the longtable
echo "\\begin{longtable}{|c|c|c|c|c|c|c|c|c|c|c|c|c|c|}" >> $output_file
echo "\\hline" >> $output_file

# Get the header row and convert it to LaTeX format
header=$(head -n 1 $input_file)
echo "$header \\\\" | sed 's/,/ \& /g' >> $output_file
echo "\\hline" >> $output_file
echo "\\endfirsthead" >> $output_file  # Repeat header on subsequent pages

# Add the header for subsequent pages (optional, useful if table is long)
echo "\\hline" >> $output_file
echo "$header \\\\" | sed 's/,/ \& /g' >> $output_file
echo "\\hline" >> $output_file
echo "\\endhead" >> $output_file

# Process the remaining lines (data rows)
tail -n +2 $input_file | while IFS= read -r line; do
  echo "$line \\\\" | sed 's/,/ \& /g' >> $output_file
  echo "\\hline" >> $output_file
done

# End the longtable
echo "\\end{longtable}" >> $output_file

# End the center environment
echo "\\end{center}" >> $output_file

# Write the ending of the LaTeX document
echo "\\end{document}" >> $output_file
