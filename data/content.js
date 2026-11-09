/* PUBLICATION CONTENT FILE — Edit and redeploy this file to update the existing URL/QR code.
   Numbers are deliberately left blank until verified study outputs are added.
   Data records are plain JavaScript objects so the site also opens locally. */
window.RESEARCH_DATA = {
  updated: 'Draft — last revised 11/09/2026',
  sections: [
    {title:'Abstract',body:'How do class scheduling patterns vary across academic units within a university, and how are these differences associated with course characteristics? This observational study addresses these questions using Purdue University’s West Lafayette campus as a case study. Drawing on administrative course-section records from the UniTime scheduling system across multiple academic terms, the analysis compares scheduling patterns across colleges and subject areas. Records without published meeting times, travel-time entries, duplicate sections, and sections with no enrollment are excluded. For each academic unit, the study calculates the proportions of sections beginning before 9 a.m., after 5 p.m., together with the mean start time. Additional comparisons examine how these patterns vary by course level, meeting duration, enrollment, section capacity, and instructional format, while comparisons across terms assess the consistency of observed patterns. Preliminary observations of early-starting clinical sections illustrate the importance of considering instructional format when interpreting differences between academic units. Rather than estimating effects on student performance or interpreting scheduling differences alone as evidence of inequity, the study characterizes the distribution of class times and identifies patterns that warrant further investigation. The case study provides an empirical foundation for discussions of scheduling equity and resource allocation, while offering a replicable framework for comparative research across higher education institutions.'},
    {title:'Research question',body:'How do scheduled class times vary across Purdue subjects and colleges, and how stable are these patterns across semesters?'},
    {title:'Why it matters',body:'Class scheduling influences student course options, campus operations, and how the academic day is distributed.  It matters to any student or professor beholden to academic scheduling, as scheduling has been shown to have significant effects and associations on outcomes (grades, program success).'},
    {title:'Research design',body:'This is descriptive and data at hand/population. It’s reach is Purdue, West Lafayette campus, Fall and Spring 2026 (data from 2024 and 2025 will be added later).'},
    {title:'Data & exclusions',body:'Duplicate sections were not counted twice for one metric. If the course had multiple subject codes, it was counted for both subjects but not double counted on the college level. Courses with zero enrollment, a listed time of "arranged hours", or a course time of "travel time" were removed from sampling but are available for perusement.'},
    {title:'Measures & inference',body:'Proportion before 9:00 AM, after 5:00 PM, outside the 9–5 window, and mean start time. Sections with multiple times were considered as meeting a proportion (i.e. outside of the 9-to-5) if any one time of that section meets the proportion. All times for a section were averaged for the average start time.'}
  ],
  metrics:[{id:'before9',name:'Before 9 AM'},{id:'after5',name:'After 5 PM'},{id:'outside',name:'Outside 9–5'},{id:'start',name:'Average start time'}],
  /* Each interval: {college:'Engineering', other:'Science', metric:'before9', lower:-0.12, upper:0.07, estimate:-0.02}. Use start values in minutes. */
  intervals:{main:[],lecture:[]},
  /* Subject rows, one per code. Example keys: subject,sections,meanStart,sdStart,before9Count,before9Prop,after5Count,after5Prop,outsideCount,outsideProp */
  subjects:{f26:[],s26:[]},
  /* College rows: college,sections,meanStart,sdStart,before9Count,before9Prop,after5Count,after5Prop,outsideCount,outsideProp */
  colleges:{combined:[],f26:[],s26:[]},
  /* Semester change rows: subject,f26Sections,s26Sections,before9PctChange,after5PctChange,outsidePctChange,startPctChange */
  semesterDifferences:[],
  semesterHighlights:[],
  significantFiles:[
    {title:'College-level significant intervals',description:'Full table of significant pairwise college comparisons.',href:'files/significant_college_intervals.csv'},
    {title:'Subject-level significant intervals',description:'Full table of significant pairwise subject comparisons.',href:'files/significant_subject_intervals.csv'},
    {title:'Complete college interval output',description:'All college comparisons, including nonsignificant intervals.',href:'files/all_college_intervals.csv'},
    {title:'Complete subject interval output',description:'All subject comparisons, including nonsignificant intervals.',href:'files/all_subject_intervals.csv'}
  ],
  regression:{status:'Planned analysis',question:'[Specify the binary outcome and model question.]',outcome:'[Name and define the binary dependent variable.]',predictors:'[List predictors and how they are encoded.]',methods:'[Specify model, standard errors, controls, and validation.]',findings:'[Add coefficients, odds ratios, intervals, performance, and limitations after fitting.]'},
  checks:[
    {title:'Random-group null check',status:'Add verified outcome',description:'Randomly form two groups of sections and test whether the constructed difference intervals reject the null at the chosen confidence level. Record sample size, number of trials, seed, and frequency of rejections.'},
    {title:'9:30 AM threshold sensitivity',status:'Add verified outcome',description:'Recalculate the early-class measure using 9:30 AM instead of 9:00 AM, and compare the resulting estimates and inferential conclusions.'},
    {title:'Lecture-only specification',status:'Add verified outcome',description:'Restrict the included records to lecture sections, then reproduce college-level comparison intervals.'},
    {title:'Duplicate section audit',status:'Add verified outcome',description:'Detect repeated section codes and reconcile conflicting published start times, documenting how duplicate records were combined.'},
    {title:'Exclusion & enrollment audit',status:'Add verified outcome',description:'Confirm how arranged-hours, travel-time, zero-enrollment, and non-lecture sections were identified and excluded.'},
    {title:'Minimum sample-size restrictions',status:'Add verified outcome',description:'Document which inference and percent-difference outputs apply minimum sample-size thresholds and how many groups were excluded.'}
  ],
  aiDisclosure:'[Replace with an accurate disclosure. Suggested structure: identify AI tools used, their roles in writing or debugging MATLAB and building the website, how outputs were independently checked, and which decisions and interpretations remained the researcher’s. Do not claim verification that was not done.]',
  appendices:{
    arrange:{title:'Arrange-hours records',description:'Section rows flagged as arranged hours. These should be excluded from scheduled-time calculations.',columns:['Subject','Course','Section','Published time','Reason'],rows:[],file:'files/arrange_hours.csv'},
    zero:{title:'Zero-enrollment records',description:'Section rows excluded because applicable enrollment was zero.',columns:['Subject','Course','Section','Enrollment','Reason'],rows:[],file:'files/zero_enrollment.csv'},
    travel:{title:'Travel-time records',description:'Section rows identified as travel time and removed from instructional meeting-time metrics.',columns:['Subject','Course','Section','Published time','Reason'],rows:[],file:'files/travel_time.csv'}
  },
  code:'% REPLACE THIS PLACEHOLDER WITH YOUR VERIFIED MATLAB ANALYSIS.\n% Include the final main script and document dependencies.\n\n% Input: HONR_Data/F26 and HONR_Data/S26\n% Output: subject tables, college summaries, interval comparisons\n'
};
