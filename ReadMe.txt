How to use these functions:

0. Add this folder (Final functions) and all its subfolders to your search path.


A) For a single folder:
1. Go to the folder containing the behavioral files (*.tdms and .txt log file).
2. Run lick_traces_reactime([b,t]), where b & t are bottom and top thresholds for licks respectively. Check function description for more details.
3. From the files produced, transfer trials_data.mat and RT.mat to the folder containing all the other analysis files for that particular day of the mouse, e.g. Data_per_mouse/mouse14/20170808/a/Matt_files in case of Ariel Gilad's data.
	If you don't want to do this manually, modify the paths on transferFiles.m and use that to automatically transfer these files.
4. Ensure that you have trails_ind.mat and move_vectors_from_movie.mat or move_vectors_M2_start_forelimb_end.mat in the folder where you moved the above files. If you are unsure of how to produce these files, contact Ariel Gilad.
5. Run moveTime.m
6. Run quietTrials.m


B) For multiple folders at a time:
1. Go to the folder that contains multiple days (folders) containing the behavioral files (*.tdms and .txt log file).
2. Run autorun_lick_traces(dates,thresholds). You can find a description of how to enter these parameters in the function description.
3-6. Follow same steps as in A