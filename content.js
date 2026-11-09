/* PUBLICATION CONTENT FILE — Edit and redeploy this file to update the existing URL/QR code.
   Numbers are deliberately left blank until verified study outputs are added.
   Data records are plain JavaScript objects so the site also opens locally. */
window.RESEARCH_DATA = {
  updated: 'Draft — add your last revised date',
  sections: [
    {title:'Abstract',body:'[Add your final abstract: context, data, method, key findings, and implications.]'},
    {title:'Research question',body:'How do scheduled class times vary across Purdue subjects and colleges, and how stable are these patterns across semesters?'},
    {title:'Why it matters',body:'Class scheduling influences student course options, campus operations, and how the academic day is distributed. [Add your specific motivation and evidence.]'},
    {title:'Research design',body:'Observational comparison of published section times across Spring and Fall 2026, summarized by subject and college. [Add a precise identification and aggregation plan.]'},
    {title:'Data & exclusions',body:'Published class times, section identifiers, types, and enrollment. Document how duplicate sections, zero enrollment, arranged hours, travel time, and non-lecture components are handled.'},
    {title:'Measures & inference',body:'Proportion before 9:00 AM, after 5:00 PM, outside the 9–5 window, and mean start time. Document the exact interval construction, units, and significance threshold.'}
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
