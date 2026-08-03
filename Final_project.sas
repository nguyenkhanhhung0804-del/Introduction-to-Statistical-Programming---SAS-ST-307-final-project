/*
	Author: Hung Nguyen, Addison Pope
	Date: April 30th, 2026
	Purpose: ST 307 Project
*/
ODS PDF FILE = "/home/u64429105/Project/ST 307 Project.pdf";
/*************************************************
PART 1: GUIDED QUESTIONS
*************************************************/

/* Part 1, Question 1:
There are some benefits of statistical programming languages (SAS or R) instead of something more 
point-and-clicked like Excel:
1. Reproductibility
- We can return back to the exact analysis anytime with SAS or R
- Other people may be able to contribute to our work
2. Automation, efficiency, reliability
- We can apply same process in the code to many other data files
- The output from our code execution produces automatic reports, which can be changed when we change
our codes
3. "Project pipeline"
- Programming languages like SAS or R are more appropriate for doing a data analysis project
in terms of reporting and visualization format
- R and SAS Code integrates with tools like Git, allowing us to track changes over time and get
recommendation from coding community
(Hung Nguyen and Addison Pope worked on this problem)
*/

/* Part 1, Question 2:
First, obtain the data file and do some data cleaning in order to have a clean dataset.
Second, look at the questions that need to be answered and identify key variables 
that can help answer the questions. Third, think about types of graphs or charts we can 
create and codes we can execute in order to create data visualization based on key variables 
that were determined
(Addison Pope worked on this problem)
*/

* Part 1, Question 3;
LIBNAME OutputDS "/home/u64429105/Raw Data";
DATA OutputDS.learn;
	INFILE "/home/u64429105/Raw Data/study.csv" DSD FIRSTOBS=2;
	ATTRIB first length=$20
		   last length=$20
		   gender length=$10
		   prevEdu length=$20;
	INPUT first last gender score prevEdu studyHrs python;
	genders = UPCASE(gender);
	DROP gender;
RUN;
* We used UPCASE() function in SAS, which we got reference from
https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/lefunctionsref/p0ilulfezdl4ykn17295t8tnh4xc.htm
to format two values MALE and FEMALE in genders column;

PROC PRINT DATA=outputds.learn(OBS=10);
RUN;
* (Hung Nguyen worked on this problem);

* Part 1, Question 4;
PROC MEANS DATA=OutputDS.learn maxdec=1
		   Q1 MEAN MEDIAN Q3 STD;
    CLASS prevEdu;
	VAR score;
RUN;
* (Hung Nguyen worked on this problem);

/* Part 1, Question 5:
- On average, Graduate has the highest average score and High School has the lowest average score
- High School contained the largest number of applications
- Undergraduate is the most consistent group in terms of their scores
(Addison Pope worked on this problem)
*/

* Part 1, Question 6;
ODS SELECT PearsonCorr;
PROC CORR DATA=OutputDS.learn NOPROB;
  VAR studyHrs python;
  WITH score;
RUN;

PROC SGSCATTER DATA = OutputDS.learn;
	COMPARE X = (studyHrs python)
			Y = score
			/ GROUP=Genders
			REG=(NOGROUP);
RUN;
* (Hung Nguyen worked on this problem)

/* Part 1, Question 7:
- Two correlation values are high and positive, indicating a strong positive linear
relationship between studyHrs and score, python and score. Because 0.80785 > 0.78755,
studyHrs is a better predictor variable than python
- Data points in the scatter plot studyHrs vs score seem to spread out more than 
data points in the scatter plot python vs score. In other words, there are more 
outliers in scatter plot studyHrs vs score than in scatter plot python vs score. 
In two plots, we also see that regression lines in scatter plot python vs score is 
better fit than regression lines in scatter plot studyHrs vs score, which contradicts 
our prediction from correlation values comparison
(Addison Pope worked on this problem)
*/

/*************************************************
PART 2: PROJECT RESEARCH QUESTIONS
*************************************************/
/* Part 2, Question 1:
1. A specific link to your dataset, or a thorough explanation of how you obtained it from a
website
- Source of data (from Kaggle): https://www.kaggle.com/datasets/zusmani/uberdrives/data
2. Who put the dataset together? When and how was it collected?
- Who put the dataset together: Zeeshan-ul-hassan Usmani collected and put data together and
published the dataset on Kaggle website
- When it was collected: January - December 2016
- How it was collected:
 + The data came from a driver’s personal Uber ride history
 + Every ride recorded by Uber includes: start time, end time, pickup location, drop-off
location, miles traveled, trip purpose (if added manually)
 + Uber allows users to download their trip history as a CSV file through their account data
export
3. How many rows are there? What does each observation represent?
- There are 1,155 rows of data in this dataset
- Each observation represents a specific Uber driver’s ride history including date, time, miles
traveled, start location and destination, and reasons for the ride
(Hung Nguyen and Addison Pope worked on this problem)
*/

* Part 2, Question 2;
LIBNAME Proposal '/home/u64429105/Project';

DATA Proposal.uber;
	INFILE "/home/u64429105/Project/My Uber Drives - 2016.csv"
		DSD DLM = "," FIRSTOBS = 2;
	ATTRIB start_date LENGTH = 8 INFORMAT = ANYDTDTM. FORMAT = DATETIME.
		   end_date LENGTH = 8 INFORMAT = ANYDTDTM. FORMAT = DATETIME.
		   category LENGTH = $10
		   start LENGTH = $20
		   stop LENGTH = $20
		   miles LENGTH = 8 FORMAT = 6.2
		   purpose LENGTH = $20;
	INPUT start_date 
		  end_date 
		  category $
	      start $
	      stop $
	      miles 
	      purpose $;
RUN;

PROC PRINT DATA = Proposal.uber(obs = 10);
RUN;

PROC CONTENTS DATA = Proposal.uber VARNUM;
RUN;
* (Hung Nguyen worked on this problem);

/* Part 2, Question 3:
- Which are the top 3 most common travelling purposes, belonging to personal or business
category, and which one of them has the longest average travelled distance?
- MILES (numerical), CATEGORY (categorical), PURPOSE (categorical)
- Target variable: average number of MILES travelled (numeric), predictor variable: 
CATEGORY (categorical) and PURPOSE (categorical). Our target variable is used to 
determine which travelling purpose and category has the most miles travelled, 
a relevant problem Uber customers may care about when travelling
- This research question is one of the factors that people commonly want to know from our 
dataset by answering some of the most popular travelling purposes and whether they are in 
the personal or business category. It also reveals which purposes tend to drive the longest 
trips, which typically costs them a significant amount of money. Uber customers should care 
most about the conclusions of our analyses because they can figure out whether they have to 
travel long distance for their personal or business purposes, and in turn can reduce the 
costs of travelling
(Hung Nguyen and Addison Pope worked on this problem)
*/

* Part 2, Question 4;
TITLE "Average miles travelled by travelling purpose and cateogry";
PROC MEANS DATA=Proposal.uber
		   MIN Q1 MEDIAN Q3 STD MAX MEAN
		   MAXDEC=1;
	 CLASS PURPOSE CATEGORY;
	 VAR MILES;
RUN;
TITLE;

TITLE1 "Histogram showing distriution of miles travelled by";
TITLE2 "travelling purpose and category";
PROC SGPANEL DATA=proposal.uber 
	(WHERE=(NOT MISSING(purpose) AND Miles < 200));
    PANELBY Category / UNISCALE=column;
    HISTOGRAM Miles / GROUP=Purpose;
RUN;
TITLE;
* (Hung Nguyen worked on this problem);

/* Part 2, Question 5:
- The most common travelling purpose is Meeting, belonging to Business category;
the second most common travelling purpose is Meal/Entertain, belonging to Business
category; the third most common travelling purpose is Errand/Supplies, belonging to 
Business category. However, Commute travelling purposes, belonging to Personal
category, has the highest average miles travelled
- Although we see that top 3 most common travelling purposes are Meeting, Meal/Entertain, 
Errand/Supplies, all belonging to Business category, none of them have the highest average 
miles travelled as we expected. The main reason behind is that people do not often travel 
long distances for these purposes, so the average miles travelled are not significantly 
high. Another reason is that people often travel long distances for Commute purposes, 
so miles travelled are high despite the low frequency. In this specific case, there is only 1 
customer travelling for Commute purposes, and that customer travelled for over 180 miles, 
making average miles travelled over 180, the highest number we recorded. By this fact,
we should not expect that the higher frequency a travelling purpose has, the higher 
the average distance travelled will be, and average value by itself does not
always reflect the whole story in the data
(Hung Nguyen and Addison Pope worked on this problem)
*/
ODS PDF CLOSE;






















	
























	
	

