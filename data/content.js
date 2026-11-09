/* PUBLICATION CONTENT FILE — Edit and redeploy this file to update the existing URL/QR code.
   Numbers are deliberately left blank until verified study outputs are added.
   Data records are plain JavaScript objects so the site also opens locally. */
window.RESEARCH_DATA = {
  updated: 'Draft — last revised 11/09/2026',
  sections: [
    {title:'Research question',body:'How do scheduled class times vary across Purdue subjects and colleges, and how stable are these patterns across semesters?'},
    {title:'Research design',body:'This is descriptive and data at hand/population. It’s reach is Purdue, West Lafayette campus, Fall and Spring 2026 (data from 2024 and 2025 will be added later).'},
    {title:'Why it matters',body:'Class scheduling influences student course options, campus operations, and how the academic day is distributed.  It matters to any student or professor beholden to academic scheduling, as scheduling has been shown to have significant effects and associations on outcomes (grades, program success).'},
    {title:'Literature discussion',body:'The main conclusion from the literature is that different scheduling patterns– early class times (Yeo et al, 2023), back to back classes (Williams & Shapiro, 2018) and the "power hour" structure (Botswick & Nguyen, 2026) –are associated with different student outcomes. This project adds data analysis on the ways different majors are scheduled and scheduling outcomes at Purdue.'},
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
  aiDisclosure:'For this project, AI (ChatGPT, Copilot, Gemini) was used in three different ways. The first was in ideation and refining the project. For this, AI was used as a peer reviewer, as required by the class, and the choices for how to proceed with the project were made using AI as input, though often proven or disproven by counter example or peer reasoning. AI was also utilized in order to search for related studies. For this, primary source reading was used; the articles were found in a separate browser and read in full in order to ensure the contents were properly understood and not misrepresented by the tool. Additional research for academic sources related to this topic was also conducted in order to look for any relevant papers the AI tool may have missed. Finally, AI, primarily ChatGPT was used for coding assistance. For this, the AI was given specific parameters for the content of the code, including variable names and functions to be created or utilized. Every line of code was read over and changed when necessary. The code was tested using the data sets available, and direct calculation was performed for some subject codes in order to ensure calculations were performed correctly.',
  appendices:{
    arrange:{title:'Arrange-hours records',description:'Section rows flagged as arranged hours. These should be excluded from scheduled-time calculations.',columns:['Subject','Course','Section','Published time','Reason'],rows:[],file:'files/arrange_hours.csv'},
    zero:{title:'Zero-enrollment records',description:'Section rows excluded because applicable enrollment was zero.',columns:['Subject','Course','Section','Enrollment','Reason'],rows:[],file:'files/zero_enrollment.csv'},
    travel:{title:'Travel-time records',description:'Section rows identified as travel time and removed from instructional meeting-time metrics.',columns:['Subject','Course','Section','Published time','Reason'],rows:[],file:'files/travel_time.csv'}
  },
  code:'% REPLACE THIS PLACEHOLDER WITH YOUR VERIFIED MATLAB ANALYSIS.\n% Include the final main script and document dependencies.\n\n% Input: HONR_Data/F26 and HONR_Data/S26\n% Output: subject tables, college summaries, interval comparisons\n'
};
