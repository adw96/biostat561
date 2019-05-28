cp cv-autogen-sph.tex cv-website.tex

echo 'Removing where papers are under review...'
sed -i -e 's/\item Under review at /\\% item Under review at /g' cv-website.tex

echo 'Removing pending applications...'
sed -i -e '/Pending applications/,/\\end/d' cv-website.tex

echo 'Removing numbering on sections...'
sed -i -e 's/\section{/\section*{/g' cv-website.tex

echo 'Removing books since I havent written any...'
sed -i -e 's/\item{Books/\\% Books/g' cv-website.tex

echo 'Removing biographical section since it is redundant...'
sed -i -e '/Biographical/,/\\end/d' cv-website.tex

echo 'Removing licensure...'
sed -i -e '/Licensure/,/\\end/d' cv-website.tex

echo 'Removing pending grant applications...'
sed -i -e '/Pending/,/\\end/d' cv-website.tex

echo 'Removing public health practice activities...'
sed -i -e '/Public Health Practice Activities/,/\\end/d' cv-website.tex

echo 'Removing professionally related community service...'
sed -i -e '/Professionally Related Community Service/,/\\end/d' cv-website.tex

echo 'Removing certain categories of mentoring that I havent done yet...'
sed -i -e '/Mentored Scientists and Postdoctoral Fellows/d' cv-website.tex

echo 'Building the pdf...'
latexmk builder >nul 2>&1
latexmk -cd -e -f -pdf -interaction=nonstopmode -synctex=1 "cv-website.tex" >nul 2>&1
latexmk builder >nul 2>&1
latexmk -cd -e -f -pdf -interaction=nonstopmode -synctex=1 "cv-website.tex" >nul 2>&1

cp cv-website.pdf /Users/adwillis/website/all/cv-website.pdf
echo 'Copying to public website...'
echo 'You will need to enter your UW password...'
scp -r  /Users/adwillis/website/all/* adwillis@ovid.u.washington.edu:public_html
