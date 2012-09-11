%%
%% This is file `clpthesis.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% CLaTeX.dtx  (with options: `clp')
%% 
%% \CheckSum{778}
%% \CharacterTable
%%  {Upper-case    \A\B\C\D\E\F\G\H\I\J\K\L\M\N\O\P\Q\R\S\T\U\V\W\X\Y\Z
%%   Lower-case    \a\b\c\d\e\f\g\h\i\j\k\l\m\n\o\p\q\r\s\t\u\v\w\x\y\z
%%   Digits        \0\1\2\3\4\5\6\7\8\9
%%   Exclamation   \!     Double quote  \"     Hash (number) \#
%%   Dollar        \$     Percent       \%     Ampersand     \&
%%   Acute accent  \'     Left paren    \(     Right paren   \)
%%   Asterisk      \*     Plus          \+     Comma         \,
%%   Minus         \-     Point         \.     Solidus       \/
%%   Colon         \:     Semicolon     \;     Less than     \<
%%   Equals        \=     Greater than  \>     Question mark \?
%%   Commercial at \@     Left bracket  \[     Backslash     \\
%%   Right bracket \]     Circumflex    \^     Underscore    \_
%%   Grave accent  \`     Left brace    \{     Vertical bar  \|
%%   Right brace   \}     Tilde         \~}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{clpthesis}[2009/04/14 CL PhD theses document class]
\newif\if@mainmatter\@mainmattertrue
\LoadClass[a4paper,11pt,abstract=true,chapterprefix,twoside]{scrbook}
\RequirePackage{fancyhdr}
\RequirePackage[english,ngerman]{babel}
\RequirePackage{a4}
\RequirePackage{graphicx}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{amsthm}
\RequirePackage[%
 bookmarks,%
 plainpages=false,%
 pdfpagelabels,%
 colorlinks=false,%
 pdfborder={0 0 0},%
]{hyperref}
\DeclareOption{english}{\AtBeginDocument{\selectlanguage{english}}}
\DeclareOption{german}{\AtBeginDocument{\selectlanguage{ngerman}}}
\ExecuteOptions{english}
\ProcessOptions\relax
\AtBeginDocument{%
 \newcommand{\degree}[1]{\renewcommand{\degreename}{#1}}
 \global\newbox\absbox%
 \renewcommand\abstractname{%
  \iflanguage{english}{Abstract}{Zusammenfassung (Englisch)}%
 }
 \newcommand\examplename{%
  \iflanguage{english}{Example}{Beispiel}%
 }
 \newcommand\exercisename{%
   \iflanguage{english}{Exercise}{Aufgabe}%
 }
 \newcommand\ackname{%
  \iflanguage{english}{Acknowledgments}{Danksagung}%
 }
 \definetoday
}
\newcommand\definetoday{%
 \renewcommand*\today{%
  \iflanguage{english}{%
   \number\day\space \ifcase\month\or%
    January\or%
    February\or%
    March\or%
    April\or%
    May\or%
    June\or%
    July\or%
    August\or%
    September\or%
    October\or%
    November\or%
    December\or%
   \fi\space \number\year
  }{%
   \number\day.~\ifcase\month\or%
    J\"anner\or%
    Februar\or%
    M\"arz\or%
    April\or%
    Mai\or%
    Juni\or%
    Juli\or%
    August\or%
    September\or%
    Oktober\or%
    November\or%
    Dezember%
   \fi\space \number\year
  }%
 }
}
\let\@OLDappendix\appendix
\renewcommand\appendix{%
\phantomsection{\addcontentsline{toc}{chapter}{\bibname}}
 \bibliographystyle{abbrv}
 \bibliography{\@bibfile}
 \@OLDappendix
}
\theoremstyle{plain}
\newtheorem{corollary}{Corollary}[%
chapter%
]
\newtheorem{lemma}[corollary]{Lemma}
\newtheorem{proposition}[corollary]{Proposition}
\newtheorem{theorem}[corollary]{Theorem}

\theoremstyle{definition}
\newtheorem{definition}[corollary]{Definition}
\newtheorem{example}[corollary]{\examplename}
\newtheorem{exercise}[corollary]{\exercisename}
\newcommand\@bibfile{biblio}
\newcommand\bibfile[1]{\renewcommand\@bibfile{#1}}
\newcommand*\@supervisor{insert the name of your supervisor}
\global\let\@supervisors\@empty
\newcommand*\@institute{insert the institute of your supervisor}
\newcommand*\institute[1]{\gdef\@institute{#1}}
\newcommand*\@mailaddress\@empty
\global\let\@matriculationnumber\@empty
\newcommand*\mailaddress[1]{\gdef\@mailaddress{#1}}
\newcommand*\matriculationnumber[1]{\gdef\@matriculationnumber{#1}}
\newcommand*\@plaintitle\@empty
\newcommand*\@plainauthor\@empty
\newcommand*\plaintitle[1]{\gdef\@plaintitle{#1}}
\newcommand*\plainauthor[1]{\gdef\@plainauthor{#1}}
\newcommand\kindname{%
 \iflanguage{english}{dissertation}{Doktorarbeit}%
}
\newcommand\supervisorname{%
 \iflanguage{english}{Supervisor}{Betreuer}%
}
\newcommand\supervisorsname{%
 \iflanguage{english}{Supervisors}{Betreuer}%
}
\newcommand\degreename{Master of Science}
\subject{\kindname}
\newcommand{\supervisor}[1]{%
 \def\@supervisor{#1}
 \publishers{\textbf{\supervisorname:} #1}
}
\newcommand{\supervisors}[1]{%
 \def\@supervisors{#1}
 \publishers{\textbf{\supervisorsname:}
  {
   \def\and{\\}
   \begin{tabular}[t]{l}
   #1
   \end{tabular}
  }
 }
}
\newcommand\abstract[1]{%
 \global\setbox\absbox=\hbox{#1}%
}
\global\let\@acknowledgments\@empty
\newcommand\acknowledgments[1]{\def\@acknowledgments{#1}}
\renewcommand*\backmatter{%
\if@openright\cleardoublepage\else\clearpage\fi
  \@mainmatterfalse%
}
\renewcommand*\maketitle[1][-1]{{%
 \renewcommand\supervisorsname{advisors}
 \renewcommand\supervisorname{advisor}
 \setcounter{page}{#1}
 \pagestyle{empty}
 \begin{center}
 {\huge\textbf{\@plaintitle}}
 \vskip3em
 {\Large\textbf{%
  \iflanguage{english}{%
   dissertation
  }{%
   Doktorarbeit in der Studienrichtung Informatik
  }
 }}
 \vskip3em
 {\Large \iflanguage{english}{by}{von}}
 \vskip3em
 {\LARGE\textbf{\@plainauthor}}\par
 \vskip3em
 {\Large\vbox{%
  \iflanguage{english}{
   submitted to the Faculty of Mathematics, Computer \\
   Science and Physics of the University of Innsbruck
   \vskip2em
   in partial fulfillment of the requirements \\
   for the degree of \degreename
  }{
   eingereicht an der \\
   Fakult\"at f\"ur Mathematik, Informatik und Physik \\
   der Universit\"at Innsbruck
   \vskip2em
   zur Erlangung des akademischen Grades \\
   \degreename
  }
 }}\par
 \vfill
 {\Large
  \vbox{
  \ifx\@supervisors\@empty
  \iflanguage{english}{%
   \expandafter\lowercase\expandafter{\supervisorname}%
  }{\supervisorname}%
  : \@supervisor
 \else
  \iflanguage{english}{%
   \expandafter\lowercase\expandafter{\supervisorsname}%
  }{\supervisorsname}%
  :
  {
   \def\and{, }
    \@supervisors
  }
 \fi
 }}\par
 \vfill
 {\Large\textbf{Innsbruck, \@date}}
 \end{center}
 \frontmatter
 \thispagestyle{empty}
 \let\footnotesize\small
 \let\footnoterule\relax
 \let\footnote\thanks
 \renewcommand*\thefootnote{\@fnsymbol\c@footnote}%
 \let\@oldmakefnmark\@makefnmark
 \renewcommand*{\@makefnmark}{\rlap\@oldmakefnmark}
 \newbox\cllbox
 \newbox\ifibox
 \newbox\unibox
 \newdimen\logoheight
 \setbox\cllbox=\hbox{\includegraphics[scale=0.36]{clshortlogo_new.pdf}}
 \setbox\ifibox=\hbox{\includegraphics[scale=0.19]{ifilogo.pdf}}
 \setbox\unibox=\hbox{\includegraphics[scale=0.2]{unilogo.png}}
 \logoheight=\ht\cllbox
 \begin{center}
 \hbox to \textwidth{%
  \rlap{\box\cllbox}
  \hfill
  \hbox{\vbox to \logoheight{\box\ifibox \vfill}}
  \hfill
  \llap{\box\unibox}
 }
 \ifx\@subject\@empty \else
  {\bigskip\Large \@subject \par}
  \vskip 3em
 \fi
 {\titlefont\huge \@title\par}
 \vskip 3em
 {\Large \lineskip 0.75em
 \begin{tabular}[t]{c}
  \@author{}
  \ifx\@matriculationnumber\@empty{}\else(\@matriculationnumber)\fi \\
  \href{mailto:\@mailaddress}{\texttt{\@mailaddress}}
 \end{tabular}\par}
 \vskip 1.5em
 {\Large \@date \par}
 \vskip \z@ \@plus3fill
 {\Large \@publishers \par}
 \vskip 3em
 \end{center}\par
 \@thanks
 \global\let\@thanks\@empty
 \vfill\null
 \vskip 3em
 \@thanks
 %\vfill\null
 \setcounter{footnote}{0}%
 \global\let\thanks\relax
 \global\let\maketitle\relax
 \global\let\@thanks\@empty
 \global\let\@author\@empty
 \global\let\@date\@empty
 \global\let\@title\@empty
 \global\let\@extratitle\@empty
 \global\let\@titlehead\@empty
 \global\let\@subject\@empty
 \global\let\@publishers\@empty
 \global\let\@uppertitleback\@empty
 \global\let\@lowertitleback\@empty
 \global\let\@dedication\@empty
 \global\let\author\relax
 \global\let\title\relax
 \global\let\extratitle\relax
 \global\let\titlehead\relax
 \global\let\subject\relax
 \global\let\publishers\relax
 \global\let\uppertitleback\relax
 \global\let\lowertitleback\relax
 \global\let\dedication\relax
 \global\let\date\relax
 \global\let\and\relax
 \clearpage
\cleardoublepage
\chapter*{Eidesstattliche Erkl{\"a}rung}
\thispagestyle{empty}

Ich erkl{\"a}re hiermit an Eides statt durch meine eigenh{\"a}ndige Unterschrift,
dass ich die vorliegende Arbeit selbst{\"a}ndig verfasst und keine anderen
als die ange\-gebenen Quellen und Hilfsmittel verwendet habe. Alle Stellen,
die w{\"o}rtlich oder inhaltlich den angegebenen Quellen entnommen wurden,
sind als solche kenntlich gemacht.

\noindent
Die vorliegende Arbeit wurde bisher in gleicher oder {\"a}hnlicher Form noch
nicht als Magister-/Master-/Diplomarbeit/Dissertation eingereicht.

\vspace{2cm}

\noindent\mbox{}
  \hskip 0pt plus .25fill
  \hrulefill
  \hskip 0pt plus .5fill
  \hrulefill
  \hskip 0pt plus .25fill
\mbox{}
\\
\noindent\mbox{}
  \hskip 0pt plus .25fill
  Datum
  \hskip 0pt plus .5fill
  Unterschrift
  \hskip 0pt plus .25fill
\mbox{}
\cleardoublepage
}}
\let\@OLDtableofcontents\tableofcontents
\renewcommand\tableofcontents{%
 \pagestyle{empty}
 \cleardoublepage
 \begin{center}
 \normalfont\sectfont\nobreak\abstractname
 \@endparpenalty\@M
 \end{center}
 \unhbox\absbox
 \par\vfil\null
 \ifx\@acknowledgments\@empty{}\else
  \cleardoublepage
  \chapter*{\ackname}
  \@acknowledgments
  \cleardoublepage
 \fi
 \@OLDtableofcontents
\cleardoublepage
 \mainmatter
 \pagestyle{fancy}
 \fancyhead{}
 \fancyfoot{}
 \renewcommand\chaptermark[1]{\markboth{\thechapter\ ##1}{}}
 \renewcommand\sectionmark[1]{\markright{\thesection\ ##1}}
 \renewcommand\headrulewidth{0.5pt}
 \fancyhead[LE]{\leftmark}
 \fancyhead[RO]{\rightmark}
 \fancyfoot[LE,RO]{\thepage}
}
\endinput
%%
%% End of file `clpthesis.cls'.
