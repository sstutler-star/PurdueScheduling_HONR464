% HONR 464 Spring 2026
% Scheduling Research Project
% Running the numbers COLLEGE?
% Author: Samantha Stutler

%% HONR 2026 SCHEDULING ANALYSIS
% Revised version:
% - Keeps exact counts for the three proportion metrics.
% - Adds start-time standard deviation.
% - Uses course + section identity so unrelated sections with the same
%   section code are not merged.
% - Duplicate meeting rows are averaged for mean start time.
% - A duplicated section counts as outside a boundary if ANY of its
%   meeting rows crosses that boundary.
% - Builds semester-level college/unit summaries from section-level records.
% - Deduplicates cross-listed sections within a college/unit.
% - Preserves a crosslisted_sections audit matrix.
% - Subject pairwise intervals use z = 5 for proportions and the matching
%   two-sided confidence level for Welch mean-start intervals.
% - College pairwise intervals use 95% confidence intervals.

%% ============================================================
% SETUP
% ============================================================

diary('HONR464_MATLAB_output_lecture.txt');
diary on;

totalTimer = tic;

scriptFolder = fileparts(mfilename('fullpath'));
if ~isempty(scriptFolder)
    cd(scriptFolder);
end


%% ============================================================
% FALL SUBJECT LISTS
% ============================================================

ag_f26 = ["AGR"; "NRES"; "AGEC"; "ASEC"; "AGRY"; "ANSC"; "BCHM"; "BTNY"; ...
    "ENTM"; "FS"; "FNR"; "HORT"; "LA"; "SFS"];

education_f26 = ["EDCI"; "EDPS"; "EDST"];

engr_f26 = ["ENGR"; "EPCS"; "GEP"; "VIP"; "ABE"; "ASM"; "CCE"; "LS"; "AAE"; ...
    "CHE"; "ECE"; "ENE"; "IDE"; "IE"; "MSE"; "ME"; "MSPE"; "NUCL"; "EEE"; "BME"];

hhs_f26 = ["HHS"; "HK"; "PES"; "HDFS"; "HSRV"; "NUTR"; "PSY"; "PUBH"; "SLHS"; ...
    "HSCI"; "CSR"; "HTM"; "NUR"];

liberalarts_f26 = ["COM"; "BAND"; "GS"; "LALS"; "REL"; "SCLA"; "ANTH"; "CMPL"; ...
    "ENGL"; "HIST"; "PHIL"; "POL"; "SOC"; "AD"; "DANC"; "FLM"; "FVS"; "HER"; ...
    "MUS"; "THTR"; "AAS"; "AMST"; "ASAM"; "CDIS"; "GSLA"; "IDIS"; "JWST"; ...
    "LING"; "MARS"; "WGSS"; "ARAB"; "ASL"; "CHNS"; "CLCS"; "FR"; "GER"; "GREK"; ...
    "HEBR"; "ITAL"; "JPNS"; "KOR"; "LATN"; "LC"; "PTGS"; "RUSS"; "SPAN"];

pharmacy_f26 = ["NUPH"; "PHSC"; "IMPH"; "IPPH"; "MCMP"; "CLPH"; "PHAD"; ...
    "PHPR"; "PHRM"];

science_f26 = ["SCI"; "BIOL"; "CHM"; "CS"; "EAPS"; "MA"; "MATH"; "ASTR"; ...
    "PHYS"; "QSCI"; "STAT"];

vet_f26 = ["VM"; "BMS"; "CPB"; "VCS"];

library_f26 = ["ILS"; "LIBR"];

business_f26 = ["ACCT"; "DSB"; "IBE"; "REAL"; "ECON"; "FIN"; "MIS"; "MKTG"; ...
    "OBHR"; "QM"; "STRT"; "SCOM"];

provost_f26 = ["TDM"; "ENTR"; "DCTC"; "SYS"];

polytech_f26 = ["NS"; "OLS"; "TLI"; "SFT"; "MSL"; "PTEC"; "TCM"; "TECH"; "CGT"; ...
    "CIT"; "CNIT"; "AFT"; "AT"; "ARCH"; "CEMT"; "CM"; "FMGT"; "INT"; "ECET"; ...
    "ENGT"; "HEMT"; "IET"; "IT"; "MET"; "MFET"];

subjects_f26 = [ ...
    ag_f26;
    education_f26;
    engr_f26;
    hhs_f26;
    liberalarts_f26;
    pharmacy_f26;
    science_f26;
    vet_f26;
    "EXPL";
    "GRAD";
    "HONR";
    library_f26;
    business_f26;
    provost_f26;
    polytech_f26;
    "SA"
    ];


%% ============================================================
% SPRING SUBJECT LISTS
% ============================================================

ag_s26 = ["AGR"; "NRES"; "AGEC"; "ASEC"; "AGRY"; "ANSC"; "BCHM"; "BTNY"; ...
    "ENTM"; "FS"; "FNR"; "HORT"; "LA"; "SFS"];

education_s26 = ["EDCI"; "EDPS"; "EDST"];

engr_s26 = ["ENGR"; "EPCS"; "GEP"; "VIP"; "ABE"; "ASM"; "CE"; "CEM"; "LS"; ...
    "AAE"; "CHE"; "ECE"; "ENE"; "IDE"; "IE"; "MSE"; "ME"; "MSPE"; ...
    "NUCL"; "EEE"; "BME"];

hhs_s26 = ["HHS"; "HK"; "PES"; "HDFS"; "HSRV"; "NUTR"; "PSY"; "PUBH"; ...
    "SLHS"; "HSCI"; "CSR"; "HTM"; "NUR"; "RECR"; "TCEM"];

liberalarts_s26 = ["COM"; "BAND"; "GS"; "LALS"; "REL"; "SCLA"; "ANTH"; "CMPL"; ...
    "ENGL"; "HIST"; "PHIL"; "POL"; "SOC"; "AD"; "DANC"; "FLM"; "FVS"; "HER"; ...
    "MUS"; "THTR"; "AAS"; "AMST"; "ASAM"; "CDIS"; "GSLA"; "IDIS"; "JWST"; ...
    "LING"; "MARS"; "WGSS"; "ARAB"; "ASL"; "CHNS"; "CLCS"; "FR"; "GER"; "GREK"; ...
    "HEBR"; "ITAL"; "JPNS"; "KOR"; "LATN"; "LC"; "PTGS"; "RUSS"; "SPAN"];

pharmacy_s26 = ["NUPH"; "PHSC"; "IMPH"; "IPPH"; "MCMP"; "CLPH"; "PHAD"; ...
    "PHPR"; "PHRM"];

science_s26 = ["SCI"; "BIOL"; "CHM"; "CS"; "CSCI"; "AIS"; "INFO"; "EAPS"; ...
    "MA"; "MATH"; "ASTR"; "PHYS"; "QSCI"; "STAT"];

vet_s26 = ["VM"; "BMS"; "CPB"; "VCS"];

library_s26 = ["ILS"; "LIBR"];

business_s26 = ["ECON"; "MGMT"; "OBHR"];

provost_s26 = ["TDM"; "ENTR"; "DCTC"; "SYS"];

polytech_s26 = ["NS"; "OLS"; "TLI"; "MSL"; "PTEC"; "TCM"; "TECH"; "CGT"; ...
    "CIT"; "CIMT"; "CNIT"; "AFT"; "AT"; "ARCH"; "CEMT"; "CM"; "FMGT"; ...
    "INT"; "ECET"; "ENGT"; "HEMT"; "IET"; "IT"; "MET"; "MFET"; "NEWM"];

subjects_s26 = [ ...
    ag_s26;
    education_s26;
    engr_s26;
    hhs_s26;
    liberalarts_s26;
    pharmacy_s26;
    science_s26;
    vet_s26;
    "EXPL";
    "GRAD";
    "HONR";
    library_s26;
    business_s26;
    provost_s26;
    polytech_s26;
    "SA"
    ];


%% ============================================================
% COLLEGE / UNIT DEFINITIONS
%
% These are built directly from your existing subject vectors.
% Standalone codes EXPL, GRAD, HONR, and SA are not assigned to a
% college/unit here because they are not contained in one of the vectors.
% ============================================================

collegeNames_f26 = [ ...
    "Agriculture";
    "Education";
    "Engineering";
    "Health and Human Sciences";
    "Liberal Arts";
    "Pharmacy";
    "Science";
    "Veterinary Medicine";
    "Libraries";
    "Business";
    "Provost";
    "Polytechnic"];

collegeSubjects_f26 = { ...
    ag_f26;
    education_f26;
    engr_f26;
    hhs_f26;
    liberalarts_f26;
    pharmacy_f26;
    science_f26;
    vet_f26;
    library_f26;
    business_f26;
    provost_f26;
    polytech_f26};

collegeNames_s26 = [ ...
    "Agriculture";
    "Education";
    "Engineering";
    "Health and Human Sciences";
    "Liberal Arts";
    "Pharmacy";
    "Science";
    "Veterinary Medicine";
    "Libraries";
    "Business";
    "Provost";
    "Polytechnic"];

collegeSubjects_s26 = { ...
    ag_s26;
    education_s26;
    engr_s26;
    hhs_s26;
    liberalarts_s26;
    pharmacy_s26;
    science_s26;
    vet_s26;
    library_s26;
    business_s26;
    provost_s26;
    polytech_s26};


%% ============================================================
% NORMALIZE SUBJECT LISTS
% ============================================================

subjects_f26 = normalizeSubjects(subjects_f26);
subjects_s26 = normalizeSubjects(subjects_s26);


%% ============================================================
% SPECIAL EXCLUDED / AUDIT ROW MATRICES
% ============================================================

arrange_hours = cell(0,0);
travel_time = cell(0,0);
zero_enrollment = cell(0,0);

% Cross-listed raw rows are stored here for auditing. Metadata is prepended:
% Semester | Source Subject | Excel File | Excel Row | Canonical Course ID | raw row...
crosslisted_sections = cell(0,0);


%% ============================================================
% FALL 2026
% ============================================================

[f26_data, arrange_hours, travel_time, zero_enrollment, ...
    f26_sections, crosslisted_sections] = ...
    processSemester( ...
    subjects_f26, ...
    "f26", ...
    arrange_hours, ...
    travel_time, ...
    zero_enrollment, ...
    crosslisted_sections);


%% ============================================================
% SPRING 2026
% ============================================================

[s26_data, arrange_hours, travel_time, zero_enrollment, ...
    s26_sections, crosslisted_sections] = ...
    processSemester( ...
    subjects_s26, ...
    "s26", ...
    arrange_hours, ...
    travel_time, ...
    zero_enrollment, ...
    crosslisted_sections);


%% ============================================================
% BUILD COLLEGE / UNIT SUMMARIES
%
% Cross-listed physical sections are deduplicated WITHIN a college/unit
% before its statistics are calculated.
% ============================================================

f26_college_data = buildCollegeData( ...
    f26_sections, collegeNames_f26, collegeSubjects_f26);

s26_college_data = buildCollegeData( ...
    s26_sections, collegeNames_s26, collegeSubjects_s26);


%% ============================================================
% MAKE TITLED SUBJECT TABLES
%
% Counts and SD remain in *_data but are intentionally not displayed.
% ============================================================

f26_table = cell2table(f26_data(:,1:6), ...
    'VariableNames', { ...
    'Subject', ...
    'Number_of_Sections', ...
    'Average_Start_Time_Minutes', ...
    'Morning_Outside9to5_Proportion', ...
    'Evening_Outside9to5_Proportion', ...
    'Overall_Outside9to5_Proportion'});

s26_table = cell2table(s26_data(:,1:6), ...
    'VariableNames', { ...
    'Subject', ...
    'Number_of_Sections', ...
    'Average_Start_Time_Minutes', ...
    'Morning_Outside9to5_Proportion', ...
    'Evening_Outside9to5_Proportion', ...
    'Overall_Outside9to5_Proportion'});


%% ============================================================
% MAKE TITLED COLLEGE / UNIT TABLES
%
% Counts and SD remain in *_college_data but are intentionally not displayed.
% ============================================================

f26_college_table = cell2table(f26_college_data(:,1:6), ...
    'VariableNames', { ...
    'College', ...
    'Number_of_Sections', ...
    'Average_Start_Time_Minutes', ...
    'Morning_Outside9to5_Proportion', ...
    'Evening_Outside9to5_Proportion', ...
    'Overall_Outside9to5_Proportion'});

s26_college_table = cell2table(s26_college_data(:,1:6), ...
    'VariableNames', { ...
    'College', ...
    'Number_of_Sections', ...
    'Average_Start_Time_Minutes', ...
    'Morning_Outside9to5_Proportion', ...
    'Evening_Outside9to5_Proportion', ...
    'Overall_Outside9to5_Proportion'});


%% ============================================================
% DISPLAY RESULTS
% ============================================================

disp("Fall 2026 subjects:")
disp(f26_table)

disp("Spring 2026 subjects:")
disp(s26_table)

disp("Fall 2026 colleges/units:")
disp(f26_college_table)

disp("Spring 2026 colleges/units:")
disp(s26_college_table)

fprintf('\nExcluded Arrange Hours rows: %d\n', size(arrange_hours,1));
fprintf('Excluded Travel Time rows: %d\n', size(travel_time,1));
fprintf('Excluded Zero Enrollment rows: %d\n', size(zero_enrollment,1));
fprintf('Cross-listed audit rows: %d\n', size(crosslisted_sections,1));


%% ============================================================
% FALL / SPRING SUBJECT ERROR COMPARISON
% ============================================================

[commonSubjects, idxF, idxS] = intersect( ...
    string(f26_table.Subject), ...
    string(s26_table.Subject), ...
    'stable');

fNum = f26_table.Number_of_Sections(idxF);
sNum = s26_table.Number_of_Sections(idxS);

fStart = f26_table.Average_Start_Time_Minutes(idxF);
sStart = s26_table.Average_Start_Time_Minutes(idxS);

fMorning = f26_table.Morning_Outside9to5_Proportion(idxF);
sMorning = s26_table.Morning_Outside9to5_Proportion(idxS);

fEvening = f26_table.Evening_Outside9to5_Proportion(idxF);
sEvening = s26_table.Evening_Outside9to5_Proportion(idxS);

fOverall = f26_table.Overall_Outside9to5_Proportion(idxF);
sOverall = s26_table.Overall_Outside9to5_Proportion(idxS);

startTimeDifference = averagePercentDifference(fStart, sStart);
morningDifference = averagePercentDifference(fMorning, sMorning);
eveningDifference = averagePercentDifference(fEvening, sEvening);
overallDifference = averagePercentDifference(fOverall, sOverall);

error_26 = table( ...
    commonSubjects, ...
    fNum, ...
    sNum, ...
    startTimeDifference, ...
    morningDifference, ...
    eveningDifference, ...
    overallDifference, ...
    'VariableNames', { ...
    'Subject', ...
    'F26_Number_of_Sections', ...
    'S26_Number_of_Sections', ...
    'Start_Time_Avg_Percent_Difference', ...
    'Morning_Avg_Percent_Difference', ...
    'Evening_Avg_Percent_Difference', ...
    'Overall_Avg_Percent_Difference'});

% Preserve your original choice not to display the all-subject table.
% disp("Fall/Spring 2026 Comparison - All Subjects:")
% disp(error_26)

meanStartTimeDifference_All = mean(startTimeDifference,'omitnan');
meanMorningDifference_All = mean(morningDifference,'omitnan');
meanEveningDifference_All = mean(eveningDifference,'omitnan');
meanOverallDifference_All = mean(overallDifference,'omitnan');
meanNumberClasses_All = mean([fNum; sNum],'omitnan');

fprintf('\n');
fprintf('===============================================\n');
fprintf('ALL MATCHED SUBJECT CODES\n');
fprintf('===============================================\n');
fprintf('Average start-time percent difference: %.2f%%\n', meanStartTimeDifference_All);
fprintf('Average morning proportion percent difference: %.2f%%\n', meanMorningDifference_All);
fprintf('Average evening proportion percent difference: %.2f%%\n', meanEveningDifference_All);
fprintf('Average overall 9-to-5 proportion percent difference: %.2f%%\n', meanOverallDifference_All);
fprintf('Average number of classes: %.2f\n\n', meanNumberClasses_All);

eligible20 = ...
    ~isnan(fNum) & ...
    ~isnan(sNum) & ...
    fNum >= 20 & ...
    sNum >= 20;

subjects20 = commonSubjects(eligible20);
fNum20 = fNum(eligible20);
sNum20 = sNum(eligible20);
fStart20 = fStart(eligible20);
sStart20 = sStart(eligible20);
fMorning20 = fMorning(eligible20);
sMorning20 = sMorning(eligible20);
fEvening20 = fEvening(eligible20);
sEvening20 = sEvening(eligible20);
fOverall20 = fOverall(eligible20);
sOverall20 = sOverall(eligible20);

startTimeDifference20 = averagePercentDifference(fStart20, sStart20);
morningDifference20 = averagePercentDifference(fMorning20, sMorning20);
eveningDifference20 = averagePercentDifference(fEvening20, sEvening20);
overallDifference20 = averagePercentDifference(fOverall20, sOverall20);

error_26_20plus = table( ...
    subjects20, ...
    fNum20, ...
    sNum20, ...
    startTimeDifference20, ...
    morningDifference20, ...
    eveningDifference20, ...
    overallDifference20, ...
    'VariableNames', { ...
    'Subject', ...
    'F26_Number_of_Sections', ...
    'S26_Number_of_Sections', ...
    'Start_Time_Avg_Percent_Difference', ...
    'Morning_Avg_Percent_Difference', ...
    'Evening_Avg_Percent_Difference', ...
    'Overall_Avg_Percent_Difference'});

disp("Fall/Spring 2026 Comparison - At Least 20 Sections in Both Semesters:")
disp(error_26_20plus)

meanStartTimeDifference_20 = mean(startTimeDifference20,'omitnan');
meanMorningDifference_20 = mean(morningDifference20,'omitnan');
meanEveningDifference_20 = mean(eveningDifference20,'omitnan');
meanOverallDifference_20 = mean(overallDifference20,'omitnan');
meanNumberClasses_20 = mean([fNum20; sNum20],'omitnan');
numberEligible20 = sum(eligible20);

fprintf('\n');
fprintf('===============================================\n');
fprintf('SUBJECTS WITH AT LEAST 20 SECTIONS IN BOTH SEMESTERS\n');
fprintf('===============================================\n');
fprintf('Number of qualifying subject codes: %d\n', numberEligible20);
fprintf('Average start-time percent difference: %.2f%%\n', meanStartTimeDifference_20);
fprintf('Average morning proportion percent difference: %.2f%%\n', meanMorningDifference_20);
fprintf('Average evening proportion percent difference: %.2f%%\n', meanEveningDifference_20);
fprintf('Average overall 9-to-5 proportion percent difference: %.2f%%\n', meanOverallDifference_20);
fprintf('Average number of classes: %.2f\n', meanNumberClasses_20);


%% ============================================================
% COMBINE FALL + SPRING SUMMARIES FOR 2026 INTERVAL ANALYSES
% ============================================================

combined_subject_26 = combineSemesterSummaries(f26_data, s26_data);
combined_college_26 = combineSemesterSummaries(f26_college_data, s26_college_data);

college_26_table = cell2table(combined_college_26(:,1:6), ...
    'VariableNames', { ...
    'College', ...
    'Number_of_Sections', ...
    'Average_Start_Time_Minutes', ...
    'Morning_Outside9to5_Proportion', ...
    'Evening_Outside9to5_Proportion', ...
    'Overall_Outside9to5_Proportion'});

disp("Combined 2026 colleges/units:")
disp(college_26_table)


%% ============================================================
% SUBJECT-LEVEL PAIRWISE INTERVALS
%
% Minimum total N = 5 per subject.
% Proportion intervals use z = 5.
% Mean-start intervals use the equivalent TWO-SIDED confidence level.
% ============================================================

subjectZ = 6;
subjectMeanConfidence = erf(subjectZ / sqrt(2));
subjectMinimumN = 5;

significant_subject_CIs = runPairwiseIntervals( ...
    combined_subject_26, ...
    "Subject", ...
    subjectMinimumN, ...
    subjectZ, ...
    subjectMeanConfidence, ...
    "z = 6");


%% ============================================================
% COLLEGE-LEVEL PAIRWISE INTERVALS
%
% Minimum total N = 5 per college/unit.
% All intervals are 95%.
% ============================================================

collegeZ = 3.290526731; %2.576  % about 99%
collegeMeanConfidence = 0.999;
collegeMinimumN = 5;

significant_college_CIs = runPairwiseIntervals( ...
    combined_college_26, ...
    "College", ...
    collegeMinimumN, ...
    collegeZ, ...
    collegeMeanConfidence, ...
    "99.9%");



%% ============================================================
% ALL COLLEGE-LEVEL 99.9% CONFIDENCE INTERVALS
% ============================================================

collegeZ = 3.290526731;
collegeMeanConfidence = 0.999;
collegeMinimumN = 5;

all_college_CIs = runPairwiseIntervals( ...
    combined_college_26, ...
    "College", ...
    collegeMinimumN, ...
    collegeZ, ...
    collegeMeanConfidence, ...
    "99.9%", ...
    true);

fprintf('\nTotal program runtime: %.2f seconds\n', toc(totalTimer));

%% ============================================================
% GRAPH ALL COLLEGE-LEVEL 99.9% DIFFERENCE INTERVALS
%
% Uses:
%       all_college_CIs
%
% One figure per college.
%
% Four panels:
%   1. Average Start Time
%   2. Before 9 AM
%   3. After 5 PM
%   4. Outside 9-to-5
%
% RED:
%       99.9% confidence interval excludes zero
%
% GREY:
%       99.9% confidence interval contains zero
%
% Every comparison is oriented as:
%
%       FOCAL COLLEGE - OTHER COLLEGE
% ============================================================

% METRICS
metricNames = ["Average Start Time"; "Before 9:30 AM"; "After 5 PM";...
    "Outside 9-to-5"];

% GET ALL COLLEGES
allColleges = unique([ ...
    string(all_college_CIs.College_1); ...
    string(all_college_CIs.College_2)]);

% COLORS
significantColor = "#953735";
insignificantColor = "#000000";
figureBackground = "#cfb991";
axesBackground =  "#ffffff";

% ONE FIGURE PER COLLEGE

for c = 1:numel(allColleges)
    focalCollege = allColleges(c);

    % Create figure
    figure( ...
        'Name', char(focalCollege), ...
        'NumberTitle', 'off', ...
        'Color', figureBackground);


    tiledlayout( ...
        2, ...
        2, ...
        'TileSpacing', 'compact', ...
        'Padding', 'compact');


    sgtitle("99.9% Difference Intervals —---                                " ...
        + focalCollege, ...
        'Interpreter', 'none', ...
        'FontWeight', 'bold', 'Color', 'k');


    %% ========================================================
    % FOUR METRICS
    % ========================================================

    for m = 1:4

        nexttile;

        set(gca, ...
            'Color', axesBackground);


        metric = ...
            metricNames(m);


        %% ----------------------------------------------------
        % Select all comparisons involving focal college
        % -----------------------------------------------------

        rows = ...
            string(all_college_CIs.Metric) == metric & ...
            ( ...
            string(all_college_CIs.College_1) == focalCollege | ...
            string(all_college_CIs.College_2) == focalCollege ...
            );


        T = ...
            all_college_CIs(rows,:);


        %% ----------------------------------------------------
        % No comparisons
        % -----------------------------------------------------

        if isempty(T)

            axis off

            text( ...
                0.5, ...
                0.5, ...
                "No intervals available", ...
                'HorizontalAlignment', 'center', ...
                'Units', 'normalized');

            title( ...
                metric, ...
                'Interpreter', 'none');

            continue

        end


        %% ====================================================
        % REORIENT AS:
        %
        % FOCAL COLLEGE - OTHER COLLEGE
        % ====================================================

        numberComparisons = ...
            height(T);


        otherCollege = ...
            strings(numberComparisons,1);


        graphDifference = ...
            zeros(numberComparisons,1);


        graphLower = ...
            zeros(numberComparisons,1);


        graphUpper = ...
            zeros(numberComparisons,1);


        for r = 1:numberComparisons


            %% ------------------------------------------------
            % Focal college is College 1
            % -------------------------------------------------

            if string(T.College_1(r)) == focalCollege

                otherCollege(r) = ...
                    string(T.College_2(r));


                graphDifference(r) = ...
                    -T.Difference(r);


                graphLower(r) = ...
                    -T.CI_Lower(r);


                graphUpper(r) = ...
                    -T.CI_Upper(r);


            %% ------------------------------------------------
            % Focal college is College 2
            %
            % Reverse signs and interval direction
            % -------------------------------------------------

            else

                otherCollege(r) = ...
                    string(T.College_1(r));


                graphDifference(r) = ...
                    T.Difference(r);


                graphLower(r) = ...
                    T.CI_Upper(r);


                graphUpper(r) = ...
                    T.CI_Lower(r);

            end

        end


        %% ====================================================
        % SORT COMPARISON COLLEGES ALPHABETICALLY
        % ====================================================

        [otherCollege, order] = ...
            sort(otherCollege);


        graphDifference = ...
            graphDifference(order);


        graphLower = ...
            graphLower(order);


        graphUpper = ...
            graphUpper(order);


        %% ====================================================
        % SIGNIFICANCE BASED ON THE ACTUAL 99.9% INTERVAL
        % ====================================================

        isSignificant = ...
            graphLower < 0 | ...
            graphUpper > 0;


        %% ====================================================
        % X-AXIS MUST INCLUDE ALL CI BOUNDS
        % ====================================================

        minimumX = ...
            min([ ...
            graphUpper; ...
            graphDifference; ...
            0]);


        maximumX = ...
            max([ ...
            graphLower; ...
            graphDifference; ...
            0]);


        xRange = ...
            maximumX - minimumX;


        if xRange == 0
            xRange = 1;
        end


        xPadding = ...
            0.08 * xRange;


        %% ====================================================
        % DRAW
        % ====================================================

        hold on


        %% Zero line

        xline( ...
            0, ...
            ':', 'Color', "#632523", ...
            'LineWidth', ...
            1.25);


        %% ----------------------------------------------------
        % Draw every 99.9% difference interval
        % -----------------------------------------------------

        for r = 1:numberComparisons

            y = r;


            %% Choose color from 99.9% significance

            if isSignificant(r)

                thisColor = ...
                    significantColor;

            else

                thisColor = ...
                    insignificantColor;

            end


            %% ================================================
            % FULL 99.9% CONFIDENCE INTERVAL
            % ================================================

            line( ...
                [graphLower(r) graphUpper(r)], ...
                [y y], ...
                'Color', thisColor, ...
                'LineWidth', 2);


            %% Lower-bound cap

            line( ...
                [graphLower(r) graphLower(r)], ...
                [y-0.20 y+0.20], ...
                'Color', thisColor, ...
                'LineWidth', 1.5);


            %% Upper-bound cap

            line( ...
                [graphUpper(r) graphUpper(r)], ...
                [y-0.20 y+0.20], ...
                'Color', thisColor, ...
                'LineWidth', 1.5);


            %% Point estimate

            plot( ...
                graphDifference(r), ...
                y, ...
                'o', ...
                'MarkerFaceColor', thisColor, ...
                'MarkerEdgeColor', thisColor, ...
                'MarkerSize', 4);

        end


        %% ====================================================
        % AXES
        % ====================================================

        xlim([ ...
            minimumX-xPadding, ...
            maximumX+xPadding]);


        yticks( ...
            1:numberComparisons);


        yticklabels( ...
            otherCollege);


        ylim([ ...
            0.5, ...
            numberComparisons+0.5]);


        %% Put first comparison at top
        set(gca, 'YDir', 'reverse');

        %% ----------------------------------------------------
        % Labels
        % -----------------------------------------------------

        if metric == "Average Start Time"
            xlabel("Difference in average start time (minutes)", ...
                'Color', 'k');
        else
            xlabel("Difference in proportion (percentage points)", ...
                'Color', 'k');
        end


        title( "F&S26 "...
            + metric + " — 99.9% CIs, all types", ...
            'Interpreter', 'none', 'Color', 'k');


        ax = gca;

        % Grid color
        ax.GridColor = [0.6 0.6 0.6];
        ax.GridAlpha = 0.5;  % Grid transparency (0 to 1)

        % Box color
        ax.XColor = [0 0 0];  % Black
        ax.YColor = [0 0 0];  % Black

        % Enable grid and box
        grid on;
        box on;


        %% ====================================================
        % LEGEND
        % ====================================================

        significantLegend = ...
            plot( ...
            NaN, ...
            NaN, ...
            'o-', ...
            'Color', significantColor, ...
            'MarkerFaceColor', significantColor, ...
            'LineWidth', 3);


        insignificantLegend = ...
            plot( ...
            NaN, ...
            NaN, ...
            'o-', ...
            'Color', insignificantColor, ...
            'MarkerFaceColor', insignificantColor, ...
            'LineWidth', 3);


        lgd = legend( ...
               [significantLegend insignificantLegend], ...
                {'Significant', 'Not Significant'}, ...
                'Location', 'best');

        lgd.Color = gca().Color;  % same as graph background
        lgd.TextColor = "k";   % black

        hold off

    end

end

%% ============================================================
% LOCAL FUNCTIONS
% ============================================================

function [semester_data, arrange_hours, travel_time, zero_enrollment, ...
    section_records, crosslisted_sections] = ...
    processSemester(subjects, semester, arrange_hours, travel_time, ...
    zero_enrollment, crosslisted_sections)

    nSubjects = numel(subjects);

    % Columns:
    % 1  Subject
    % 2  Number of unique usable sections
    % 3  Average start time
    % 4  Morning proportion
    % 5  Evening proportion
    % 6  Overall outside-9-to-5 proportion
    % 7  Morning count
    % 8  Evening count
    % 9  Overall outside-9-to-5 count
    % 10 Start-time standard deviation across unique sections
    semester_data = cell(nSubjects,10);

    % Section-level records used for college aggregation.
    % Columns:
    % 1 Semester
    % 2 Source subject
    % 3 Canonical course identity
    % 4 Section code
    % 5 Physical section key
    % 6 Average start
    % 7 Average end
    % 8 Morning flag
    % 9 Evening flag
    % 10 Overall flag
    section_records = cell(0,10);

    for i = 1:nSubjects

        subject = strtrim(subjects(i));
        semester_data{i,1} = subject;

        excelFile = findExcelFile(subject, semester);

        if excelFile == ""
            screenshotFile = findScreenshot(subject, semester);

            if screenshotFile == ""
                warning('No Excel file or screenshot found for %s %s.', ...
                    char(subject), char(semester));
            end

            semester_data(i,2:10) = repmat({NaN},1,9);
            continue
        end

        try
            rawData = readcell(excelFile,"UseExcel",false);
        catch ME
            warning('Could not read %s: %s', char(excelFile), ME.message);
            semester_data(i,2:10) = repmat({NaN},1,9);
            continue
        end

        if size(rawData,2) < 8
            warning('%s contains fewer than 8 columns.', char(excelFile));
            semester_data(i,2:10) = repmat({NaN},1,9);
            continue
        end

        sectionTimes = containers.Map('KeyType','char','ValueType','any');
        sectionCourseIdentity = containers.Map('KeyType','char','ValueType','char');
        sectionDisplayCode = containers.Map('KeyType','char','ValueType','char');

        parseProblem = false;

        for r = 2:size(rawData,1)

            if rowIsBlank(rawData(r,:))
                continue
            end

            %% ------------------------------------------------
            % TRAVEL TIME
            % -------------------------------------------------

            travelText = string(rawData{r,3});

            if ~ismissing(travelText)
                travelText = strtrim(travelText);

                if strcmpi(travelText,"Travel Time")
                    travel_time = appendCellRow(travel_time,rawData(r,:));
                    continue
                end
            end

            %% Only keep Lecture rows

            meetingType = strtrim(string(rawData{r,3}));

            if ismissing(meetingType) || ...
                ~strcmpi(meetingType,"Lecture")

                continue
            end

            %% ------------------------------------------------
            % COURSE IDENTITY - COLUMN A
            % -------------------------------------------------

            [courseIdentity, aliasCount] = ...
                canonicalCourseIdentity(rawData{r,1});

            if courseIdentity == ""
                warning(['Missing/unreadable course identity in column A for ' ...
                    '%s %s, Excel row %d. Row skipped.'], ...
                    char(subject), char(semester), r);
                continue
            end

            if aliasCount > 1
                auditRow = [ ...
                    {char(semester), char(subject), char(excelFile), r, ...
                    char(courseIdentity)}, ...
                    rawData(r,:)];

                crosslisted_sections = appendCellRow( ...
                    crosslisted_sections, auditRow);
            end

            %% ------------------------------------------------
            % SECTION CODE - COLUMN B
            % -------------------------------------------------

            sectionCode = normalizeSectionCode(rawData{r,2});

            if sectionCode == ""
                warning(['Missing section code in column B for ' ...
                    '%s %s, Excel row %d. Row skipped.'], ...
                    char(subject), char(semester), r);
                continue
            end

            % Course + section is used, not section code alone.
            sectionKey = char(lower(courseIdentity + "||" + sectionCode));

            %% ------------------------------------------------
            % PUBLISHED TIME - COLUMN E
            % -------------------------------------------------

            timeText = string(rawData{r,5});
            if ~ismissing(timeText)
                timeText = strtrim(timeText);
            end

            if ~ismissing(timeText) && strcmpi(timeText,"Arrange hours")
                arrange_hours = appendCellRow(arrange_hours,rawData(r,:));
                continue
            end

            %% ------------------------------------------------
            % ZERO ENROLLMENT - COLUMN H
            % -------------------------------------------------

            if isZeroEnrollmentValue(rawData{r,8})
                zero_enrollment = appendCellRow(zero_enrollment,rawData(r,:));
                continue
            end

            %% ------------------------------------------------
            % PARSE MEETING TIME
            % -------------------------------------------------

            [startMinutes,endMinutes,ok] = parseMeetingTime(timeText);

            if ~ok
                warning(['Could not interpret time "%s" for %s %s, ' ...
                    'course %s, section %s, Excel row %d.'], ...
                    char(timeText), char(subject), char(semester), ...
                    char(courseIdentity), char(sectionCode), r);
                parseProblem = true;
                continue
            end

            newTime = [startMinutes endMinutes];

            if isKey(sectionTimes,sectionKey)
                existingTimes = sectionTimes(sectionKey);
                existingTimes(end+1,:) = newTime;
                sectionTimes(sectionKey) = existingTimes;
            else
                sectionTimes(sectionKey) = newTime;
                sectionCourseIdentity(sectionKey) = char(courseIdentity);
                sectionDisplayCode(sectionKey) = char(sectionCode);
            end
        end

        sectionKeys = keys(sectionTimes);
        numberSections = numel(sectionKeys);

        numberMorning = 0;
        numberEvening = 0;
        numberOutside = 0;
        allAverageStarts = zeros(numberSections,1);

        % Temporarily hold records for this subject. They are only released
        % to college aggregation if the subject has no parse problem.
        subjectRecords = cell(numberSections,10);

        for k = 1:numberSections

            sectionKey = sectionKeys{k};
            times = sectionTimes(sectionKey);

            averageStart = mean(times(:,1));
            averageEnd = mean(times(:,2));
            allAverageStarts(k) = averageStart;

            % Mean uses the averaged section time, but proportion flags use
            % ANY meeting occurrence for the section.
            isMorning = any(times(:,1) < 570);
            isEvening = any(times(:,2) > 1020);
            isOutside = isMorning || isEvening;

            if isMorning
                numberMorning = numberMorning + 1;
            end

            if isEvening
                numberEvening = numberEvening + 1;
            end

            if isOutside
                numberOutside = numberOutside + 1;
            end

            courseIdentity = string(sectionCourseIdentity(sectionKey));
            displaySectionCode = string(sectionDisplayCode(sectionKey));

            % Canonical key used to remove duplicate cross-listed listings
            % within a college/unit.
            physicalSectionKey = lower( ...
                string(semester) + "|" + ...
                courseIdentity + "|" + ...
                displaySectionCode);

            subjectRecords(k,:) = { ...
                char(semester), ...
                char(subject), ...
                char(courseIdentity), ...
                char(displaySectionCode), ...
                char(physicalSectionKey), ...
                averageStart, ...
                averageEnd, ...
                double(isMorning), ...
                double(isEvening), ...
                double(isOutside)};

            %% Information message for duplicated sections

            if size(times,1) > 1
                startText = minutesToClockString(averageStart);
                endText = minutesToClockString(averageEnd);

                %fprintf( ...
                 %   ['%s %s course %s section %s has %d time entries; ' ...
                 %    'average start = %s, average end = %s.\n'], ...
                 %   char(subject), ...
                 %   char(semester), ...
                 %   char(courseIdentity), ...
                 %   char(displaySectionCode), ...
                 %   size(times,1), ...
                 %   startText, ...
                 %   endText);
            end
        end

        semester_data{i,2} = numberSections;

        if numberSections == 0
            semester_data(i,3:10) = repmat({NaN},1,8);

        elseif parseProblem
            % Preserve conservative behavior: one unparseable non-excluded
            % row makes the subject statistics incomplete.
            semester_data(i,3:10) = repmat({NaN},1,8);

        else
            overallAverageStart = mean(allAverageStarts);
            startTimeSD = std(allAverageStarts,0);

            semester_data{i,3} = overallAverageStart;
            semester_data{i,4} = numberMorning / numberSections;
            semester_data{i,5} = numberEvening / numberSections;
            semester_data{i,6} = numberOutside / numberSections;
            semester_data{i,7} = numberMorning;
            semester_data{i,8} = numberEvening;
            semester_data{i,9} = numberOutside;
            semester_data{i,10} = startTimeSD;

            section_records = [section_records; subjectRecords]; %#ok<AGROW>
        end
    end
end


function college_data = buildCollegeData(section_records, collegeNames, collegeSubjects)

    nColleges = numel(collegeNames);
    college_data = cell(nColleges,10);

    if isempty(section_records)
        for i = 1:nColleges
            college_data{i,1} = collegeNames(i);
            college_data(i,2:10) = repmat({NaN},1,9);
        end
        return
    end

    recordSubjects = upper(strtrim(string(section_records(:,2))));
    physicalKeys = string(section_records(:,5));

    for i = 1:nColleges

        collegeName = collegeNames(i);
        members = normalizeSubjects(collegeSubjects{i});
        members = upper(members);

        mask = ismember(recordSubjects,members);
        idx = find(mask);

        college_data{i,1} = collegeName;

        if isempty(idx)
            college_data{i,2} = 0;
            college_data(i,3:10) = repmat({NaN},1,8);
            continue
        end

        % Remove repeated listings of the same cross-listed physical section
        % within this college/unit.
        [~,keepRelative] = unique(physicalKeys(idx),'stable');
        idx = idx(keepRelative);

        starts = cell2mat(section_records(idx,6));
        morning = cell2mat(section_records(idx,8));
        evening = cell2mat(section_records(idx,9));
        overall = cell2mat(section_records(idx,10));

        n = numel(idx);
        morningCount = sum(morning);
        eveningCount = sum(evening);
        overallCount = sum(overall);

        college_data{i,2} = n;
        college_data{i,3} = mean(starts);
        college_data{i,4} = morningCount / n;
        college_data{i,5} = eveningCount / n;
        college_data{i,6} = overallCount / n;
        college_data{i,7} = morningCount;
        college_data{i,8} = eveningCount;
        college_data{i,9} = overallCount;
        college_data{i,10} = std(starts,0);
    end
end


function combined_data = combineSemesterSummaries(fData,sData)

    fLabels = strtrim(string(fData(:,1)));
    sLabels = strtrim(string(sData(:,1)));

    labels = unique([fLabels; sLabels],'stable');
    labels = labels(~ismissing(labels) & labels ~= "");

    combined_data = cell(numel(labels),10);

    for i = 1:numel(labels)

        label = labels(i);
        combined_data{i,1} = label;

        idxF = find(fLabels == label,1);
        idxS = find(sLabels == label,1);

        ns = [];
        means = [];
        sds = [];
        morningCounts = [];
        eveningCounts = [];
        overallCounts = [];
        invalid = false;

        if ~isempty(idxF)
            n = numericCellValue(fData{idxF,2});

            if ~isnan(n) && n > 0
                vals = [ ...
                    numericCellValue(fData{idxF,3}), ...
                    numericCellValue(fData{idxF,7}), ...
                    numericCellValue(fData{idxF,8}), ...
                    numericCellValue(fData{idxF,9}), ...
                    numericCellValue(fData{idxF,10})];

                if any(isnan(vals))
                    invalid = true;
                else
                    ns(end+1,1) = n; %#ok<AGROW>
                    means(end+1,1) = vals(1); %#ok<AGROW>
                    morningCounts(end+1,1) = vals(2); %#ok<AGROW>
                    eveningCounts(end+1,1) = vals(3); %#ok<AGROW>
                    overallCounts(end+1,1) = vals(4); %#ok<AGROW>
                    sds(end+1,1) = vals(5); %#ok<AGROW>
                end
            elseif isnan(n)
                invalid = true;
            end
        end

        if ~isempty(idxS)
            n = numericCellValue(sData{idxS,2});

            if ~isnan(n) && n > 0
                vals = [ ...
                    numericCellValue(sData{idxS,3}), ...
                    numericCellValue(sData{idxS,7}), ...
                    numericCellValue(sData{idxS,8}), ...
                    numericCellValue(sData{idxS,9}), ...
                    numericCellValue(sData{idxS,10})];

                if any(isnan(vals))
                    invalid = true;
                else
                    ns(end+1,1) = n; %#ok<AGROW>
                    means(end+1,1) = vals(1); %#ok<AGROW>
                    morningCounts(end+1,1) = vals(2); %#ok<AGROW>
                    eveningCounts(end+1,1) = vals(3); %#ok<AGROW>
                    overallCounts(end+1,1) = vals(4); %#ok<AGROW>
                    sds(end+1,1) = vals(5); %#ok<AGROW>
                end
            elseif isnan(n)
                invalid = true;
            end
        end

        if invalid || isempty(ns)
            combined_data(i,2:10) = repmat({NaN},1,9);
            continue
        end

        totalN = sum(ns);
        combinedMean = sum(ns .* means) / totalN;

        if totalN > 1
            totalSS = sum((ns - 1) .* (sds .^ 2) + ...
                ns .* ((means - combinedMean) .^ 2));
            combinedSD = sqrt(totalSS / (totalN - 1));
        else
            combinedSD = 0;
        end

        morningCount = sum(morningCounts);
        eveningCount = sum(eveningCounts);
        overallCount = sum(overallCounts);

        combined_data{i,2} = totalN;
        combined_data{i,3} = combinedMean;
        combined_data{i,4} = morningCount / totalN;
        combined_data{i,5} = eveningCount / totalN;
        combined_data{i,6} = overallCount / totalN;
        combined_data{i,7} = morningCount;
        combined_data{i,8} = eveningCount;
        combined_data{i,9} = overallCount;
        combined_data{i,10} = combinedSD;
    end
end


function resultTable = runPairwiseIntervals(summaryData, levelName, ...
    minimumN, zProp, meanConfidence, confidenceLabel, keepAllIntervals)

    %% If the seventh argument is omitted, preserve the old behavior:
    % only retain intervals that exclude zero.

    if nargin < 7
        keepAllIntervals = false;
    end

    labels = string(summaryData(:,1));
    n = cellColumnToNumeric(summaryData,2);
    means = cellColumnToNumeric(summaryData,3);
    morningCount = cellColumnToNumeric(summaryData,7);
    eveningCount = cellColumnToNumeric(summaryData,8);
    overallCount = cellColumnToNumeric(summaryData,9);
    sds = cellColumnToNumeric(summaryData,10);

    eligible = ...
        n >= minimumN & ...
        ~isnan(means) & ...
        ~isnan(sds) & ...
        ~isnan(morningCount) & ...
        ~isnan(eveningCount) & ...
        ~isnan(overallCount);

    eligibleIndex = find(eligible);
    numberEligible = numel(eligibleIndex);
    numberPairs = numberEligible * (numberEligible - 1) / 2;
    numberTests = numberPairs * 4;

    maxResults = numberTests;
    result1 = strings(maxResults,1);
    result2 = strings(maxResults,1);
    resultMetric = strings(maxResults,1);
    resultN1 = zeros(maxResults,1);
    resultN2 = zeros(maxResults,1);

    % Exact numerator counts for proportion metrics.
    % These remain NaN for the mean-start-time metric.
    resultCount1 = NaN(maxResults,1);
    resultCount2 = NaN(maxResults,1);

    resultValue1 = zeros(maxResults,1);
    resultValue2 = zeros(maxResults,1);
    resultDifference = zeros(maxResults,1);
    resultLower = zeros(maxResults,1);
    resultUpper = zeros(maxResults,1);
    resultUnits = strings(maxResults,1);
    resultRow = 0;

    countMatrix = [morningCount eveningCount overallCount];
    proportionMetricNames = ["Before 9:30 AM"; "After 5 PM"; "Outside 9-to-5"];

    for a = 1:(numberEligible - 1)
        i = eligibleIndex(a);

        for b = (a + 1):numberEligible
            j = eligibleIndex(b);

            %% Mean start-time interval
            [difference,lowerCI,upperCI] = meanDifferenceFromSummary( ...
                n(i),means(i),sds(i),n(j),means(j),sds(j),meanConfidence);

            if lowerCI > 0 || upperCI < 0 || keepAllIntervals
                resultRow = resultRow + 1;
                result1(resultRow) = labels(i);
                result2(resultRow) = labels(j);
                resultMetric(resultRow) = "Average Start Time";
                resultN1(resultRow) = n(i);
                resultN2(resultRow) = n(j);
                resultValue1(resultRow) = means(i);
                resultValue2(resultRow) = means(j);
                resultDifference(resultRow) = difference;
                resultLower(resultRow) = lowerCI;
                resultUpper(resultRow) = upperCI;
                resultUnits(resultRow) = "minutes";
            end

            %% Three proportion intervals
            for m = 1:3
                x1 = countMatrix(i,m);
                x2 = countMatrix(j,m);

                [difference,lowerCI,upperCI] = ...
                    newcombeWilsonDifference(x1,n(i),x2,n(j),zProp);

                if lowerCI > 0 || upperCI < 0 || keepAllIntervals
                    resultRow = resultRow + 1;
                    result1(resultRow) = labels(i);
                    result2(resultRow) = labels(j);
                    resultMetric(resultRow) = proportionMetricNames(m);
                    resultN1(resultRow) = n(i);
                    resultN2(resultRow) = n(j);

                    % Save exact observed counts
                    resultCount1(resultRow) = x1;
                    resultCount2(resultRow) = x2;

                    resultValue1(resultRow) = 100 * x1 / n(i);
                    resultValue2(resultRow) = 100 * x2 / n(j);
                    resultDifference(resultRow) = 100 * difference;
                    resultLower(resultRow) = 100 * lowerCI;
                    resultUpper(resultRow) = 100 * upperCI;
                    resultUnits(resultRow) = "percentage points";
                end
            end
        end
    end

    result1 = result1(1:resultRow);
    result2 = result2(1:resultRow);
    resultMetric = resultMetric(1:resultRow);
    resultN1 = resultN1(1:resultRow);
    resultN2 = resultN2(1:resultRow);

    resultCount1 = resultCount1(1:resultRow);
    resultCount2 = resultCount2(1:resultRow);

    resultValue1 = resultValue1(1:resultRow);
    resultValue2 = resultValue2(1:resultRow);
    resultDifference = resultDifference(1:resultRow);
    resultLower = resultLower(1:resultRow);
    resultUpper = resultUpper(1:resultRow);
    resultUnits = resultUnits(1:resultRow);

    name1 = char(matlab.lang.makeValidName(levelName + "_1"));
    name2 = char(matlab.lang.makeValidName(levelName + "_2"));

    resultTable = table( ...
        result1, result2, resultMetric, resultN1, resultN2, ...
        resultValue1, resultValue2, resultDifference, ...
        resultLower, resultUpper, resultUnits, ...
        'VariableNames', { ...
        name1, name2, 'Metric', 'N_1', 'N_2', ...
        'Value_1', 'Value_2', 'Difference', ...
        'CI_Lower', 'CI_Upper', 'Units'});

    fprintf('\n');
    fprintf('============================================================\n');
    fprintf('%s-LEVEL 2026 PAIRWISE INTERVAL ANALYSIS\n', upper(char(levelName)));
    fprintf('============================================================\n');
    fprintf('Minimum required sections per %s: %d\n', lower(char(levelName)), minimumN);
    fprintf('Confidence setting: %s\n', char(confidenceLabel));
    fprintf('Eligible %ss: %d\n', lower(char(levelName)), numberEligible);
    fprintf('Pairs tested: %d\n', numberPairs);
    fprintf('Intervals tested: %d\n', numberTests);
    fprintf('Significant intervals: %d\n\n', resultRow);

    if resultRow == 0
        fprintf('No significant differences were found.\n');
        return
    end

    fprintf('Difference is %s 1 minus %s 2.\n\n', ...
        char(levelName), char(levelName));

    for r = 1:resultRow
        fprintf('%s vs %s | %s\n', ...
            result1(r), result2(r), resultMetric(r));

        if resultUnits(r) == "minutes"
            fprintf('    %s: %.2f minutes after midnight (N=%d)\n', ...
                result1(r), resultValue1(r), resultN1(r));
            fprintf('    %s: %.2f minutes after midnight (N=%d)\n', ...
                result2(r), resultValue2(r), resultN2(r));
            fprintf('    Difference: %.2f minutes\n', resultDifference(r));
            fprintf('    CI: [%.2f, %.2f] minutes\n', ...
                resultLower(r), resultUpper(r));
        else

            %% Subject-level proportion printing:
            % Show exact count / total, e.g. (12/55)

            if strcmpi(levelName,"Subject")

                fprintf('    %s: %.2f%% (%d/%d)\n', ...
                    result1(r), ...
                    resultValue1(r), ...
                    resultCount1(r), ...
                    resultN1(r));

                fprintf('    %s: %.2f%% (%d/%d)\n', ...
                    result2(r), ...
                    resultValue2(r), ...
                    resultCount2(r), ...
                    resultN2(r));

            else

                %% Keep college printing as N = total

                fprintf('    %s: %.2f%% (N=%d)\n', ...
                    result1(r), ...
                    resultValue1(r), ...
                    resultN1(r));

                fprintf('    %s: %.2f%% (N=%d)\n', ...
                    result2(r), ...
                    resultValue2(r), ...
                    resultN2(r));

            end


            %fprintf('    Difference: %.2f percentage points\n', ...
                %resultDifference(r));

            fprintf('    CI: [%.2f, %.2f] percentage points\n', ...
                resultLower(r), ...
                resultUpper(r));

        end

        fprintf('------------------------------------------------------------------------\n');
    end
end


function [difference,lowerCI,upperCI] = ...
    meanDifferenceFromSummary(n1,m1,sd1,n2,m2,sd2,confidenceLevel)

    difference = m1 - m2;

    v1 = sd1^2;
    v2 = sd2^2;
    standardError = sqrt(v1/n1 + v2/n2);

    if standardError == 0
        lowerCI = difference;
        upperCI = difference;
        return
    end

    denominator = ...
        (v1/n1)^2/(n1-1) + ...
        (v2/n2)^2/(n2-1);

    if denominator == 0
        df = n1 + n2 - 2;
    else
        df = (v1/n1 + v2/n2)^2 / denominator;
    end

    alpha = 1 - confidenceLevel;

    if exist('tinv','file') == 2
        tCritical = tinv(1-alpha/2,df);
    else
        betaValue = betaincinv(alpha,df/2,0.5);
        tCritical = sqrt(df * (1/betaValue - 1));
    end

    lowerCI = difference - tCritical * standardError;
    upperCI = difference + tCritical * standardError;
end


function [difference,lowerCI,upperCI] = ...
    newcombeWilsonDifference(x1,n1,x2,n2,z)

    p1 = x1 / n1;
    p2 = x2 / n2;
    difference = p1 - p2;

    denominator1 = 1 + z^2/n1;
    center1 = (p1 + z^2/(2*n1)) / denominator1;
    halfWidth1 = z * sqrt(p1*(1-p1)/n1 + z^2/(4*n1^2)) / denominator1;
    lower1 = max(0,center1-halfWidth1);
    upper1 = min(1,center1+halfWidth1);

    denominator2 = 1 + z^2/n2;
    center2 = (p2 + z^2/(2*n2)) / denominator2;
    halfWidth2 = z * sqrt(p2*(1-p2)/n2 + z^2/(4*n2^2)) / denominator2;
    lower2 = max(0,center2-halfWidth2);
    upper2 = min(1,center2+halfWidth2);

    lowerCI = difference - sqrt((p1-lower1)^2 + (upper2-p2)^2);
    upperCI = difference + sqrt((upper1-p1)^2 + (p2-lower2)^2);

    lowerCI = max(-1,lowerCI);
    upperCI = min(1,upperCI);
end

function result = averagePercentDifference(a,b)

    result = NaN(size(a));

    valid = ...
        ~isnan(a) & ...
        ~isnan(b) & ...
        a ~= 0 & ...
        b ~= 0;

    result(valid) = ( ...
        abs(a(valid)-b(valid))./abs(a(valid))*100 + ...
        abs(a(valid)-b(valid))./abs(b(valid))*100) / 2;

    bothZero = ...
        ~isnan(a) & ...
        ~isnan(b) & ...
        a == 0 & ...
        b == 0;

    result(bothZero) = 0;
end


function subjects = normalizeSubjects(subjects)

    if ischar(subjects)
        subjects = string(cellstr(subjects));
    else
        subjects = string(subjects);
    end

    subjects = strtrim(subjects(:));
    keep = ~ismissing(subjects) & strlength(subjects) > 0;
    subjects = subjects(keep);
end


function sectionCode = normalizeSectionCode(value)

    try
        sectionCode = strtrim(string(value));
    catch
        sectionCode = "";
        return
    end

    if ismissing(sectionCode) || strlength(sectionCode) == 0
        sectionCode = "";
    end
end


function [identity,aliasCount] = canonicalCourseIdentity(value)

    identity = "";
    aliasCount = 0;

    try
        textValue = string(value);
    catch
        return
    end

    if ismissing(textValue)
        return
    end

    textValue = strtrim(textValue);
    if strlength(textValue) == 0
        return
    end

    raw = char(textValue);

    % Pull subject + course-number aliases from a cell such as:
    % STAT 17000\nMA 17000
    tokens = regexp(raw, ...
        '([A-Za-z]{2,4})\s+(\d{1,5}[A-Za-z]?)', ...
        'tokens');

    if isempty(tokens)
        cleaned = upper(strtrim(regexprep(raw,'\s+',' ')));
        identity = string(cleaned);
        aliasCount = 1;
        return
    end

    aliases = strings(numel(tokens),1);

    for k = 1:numel(tokens)
        aliases(k) = upper(string(tokens{k}{1})) + " " + ...
            upper(string(tokens{k}{2}));
    end

    aliases = unique(aliases);
    aliases = sort(aliases);
    aliasCount = numel(aliases);
    identity = join(aliases,"|");
end


function tf = isZeroEnrollmentValue(value)

    tf = false;

    if isnumeric(value)
        if isscalar(value) && ~isnan(value) && value == 0
            tf = true;
        end
        return
    end

    try
        enrollmentText = strtrim(string(value));
    catch
        return
    end

    if ismissing(enrollmentText) || strlength(enrollmentText) == 0
        return
    end

    enrollmentNumber = str2double(enrollmentText);

    if ~isnan(enrollmentNumber) && enrollmentNumber == 0
        tf = true;
    end
end


function filename = findExcelFile(subject,semester)

    filename = "";
    semesterFolder = upper(semester);
    baseName = "HONR_" + subject + "_" + semester;
    extensions = [".xlsx", ".xls", ".xlsm"];

    for k = 1:numel(extensions)
        candidate = fullfile(semesterFolder,baseName + extensions(k));
        if isfile(candidate)
            filename = candidate;
            return
        end
    end
end


function filename = findScreenshot(subject,semester)

    filename = "";
    semesterFolder = upper(semester);
    baseName = subject + "_screenshot_" + semester;
    extensions = [".png", ".jpg", ".jpeg", ".tif", ".tiff", ".bmp"];

    for k = 1:numel(extensions)
        candidate = fullfile(semesterFolder,baseName + extensions(k));
        if isfile(candidate)
            filename = candidate;
            return
        end
    end
end


function [startMinutes,endMinutes,ok] = parseMeetingTime(timeText)

    startMinutes = NaN;
    endMinutes = NaN;
    ok = false;

    if ismissing(timeText)
        return
    end

    timeText = lower(strtrim(string(timeText)));

    if strlength(timeText) == 0
        return
    end

    timeText = replace(timeText,"–","-");
    timeText = replace(timeText,"—","-");

    parts = split(timeText,"-");

    if numel(parts) ~= 2
        return
    end

    [startMinutes,ok1] = parseSingleTime(strtrim(parts(1)));
    [endMinutes,ok2] = parseSingleTime(strtrim(parts(2)));
    ok = ok1 && ok2;
end


function [minutesAfterMidnight,ok] = parseSingleTime(timeText)

    minutesAfterMidnight = NaN;
    ok = false;
    timeText = lower(strtrim(string(timeText)));

    if strcmpi(timeText,"noon")
        minutesAfterMidnight = 12*60;
        ok = true;
        return
    end

    tokens = regexp( ...
        char(timeText), ...
        '^(\d{1,2}):(\d{2})\s*([ap])(?:m)?$', ...
        'tokens','once');

    if isempty(tokens)
        return
    end

    hourValue = str2double(tokens{1});
    minuteValue = str2double(tokens{2});
    ampm = lower(tokens{3});

    if hourValue < 1 || hourValue > 12 || minuteValue < 0 || minuteValue > 59
        return
    end

    if strcmp(ampm,'a')
        if hourValue == 12
            hourValue = 0;
        end
    elseif strcmp(ampm,'p')
        if hourValue ~= 12
            hourValue = hourValue + 12;
        end
    else
        return
    end

    minutesAfterMidnight = hourValue*60 + minuteValue;
    ok = true;
end


function outputText = minutesToClockString(minutesValue)

    minutesValue = round(minutesValue);
    hour24 = floor(minutesValue/60);
    minuteValue = mod(minutesValue,60);

    if hour24 == 0
        hour12 = 12;
        suffix = 'a';
    elseif hour24 < 12
        hour12 = hour24;
        suffix = 'a';
    elseif hour24 == 12
        hour12 = 12;
        suffix = 'p';
    else
        hour12 = hour24 - 12;
        suffix = 'p';
    end

    outputText = sprintf('%d:%02d%s',hour12,minuteValue,suffix);
end


function A = appendCellRow(A,newRow)

    newRow = newRow(:)';

    if isempty(A)
        A = newRow;
        return
    end

    oldWidth = size(A,2);
    newWidth = numel(newRow);

    if newWidth > oldWidth
        A(:,oldWidth+1:newWidth) = cell(size(A,1),newWidth-oldWidth);
        oldWidth = newWidth;
    end

    if newWidth < oldWidth
        newRow(newWidth+1:oldWidth) = cell(1,oldWidth-newWidth);
    end

    A(end+1,:) = newRow;
end


function tf = rowIsBlank(row)

    tf = true;

    for k = 1:numel(row)
        x = row{k};

        if isempty(x)
            continue
        end

        if isstring(x)
            if ismissing(x) || strlength(strtrim(x)) == 0
                continue
            end
        elseif ischar(x)
            if isempty(strtrim(x))
                continue
            end
        elseif isnumeric(x)
            if isscalar(x) && isnan(x)
                continue
            end
        end

        tf = false;
        return
    end
end


function value = numericCellValue(x)

    value = NaN;

    if isempty(x)
        return
    end

    if isnumeric(x) && isscalar(x)
        value = double(x);
        return
    end

    try
        value = str2double(string(x));
    catch
        value = NaN;
    end
end


function out = cellColumnToNumeric(data,columnNumber)

    out = NaN(size(data,1),1);

    for i = 1:size(data,1)
        out(i) = numericCellValue(data{i,columnNumber});
    end
end

diary off;
