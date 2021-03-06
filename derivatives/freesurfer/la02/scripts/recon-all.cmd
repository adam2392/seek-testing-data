

#---------------------------------
# New invocation of recon-all Sun May 31 17:10:06 EDT 2020 
#--------------------------------------------
#@# MotionCor Sun May 31 17:10:07 EDT 2020

 cp /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/la02/mri/orig/001.mgz /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/la02/mri/rawavg.mgz 


 mri_convert /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/la02/mri/rawavg.mgz /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/la02/mri/orig.mgz --conform --cw256 


 mri_add_xform_to_header -c /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/la02/mri/transforms/talairach.xfm /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/la02/mri/orig.mgz /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/la02/mri/orig.mgz 

#--------------------------------------------
#@# Talairach Sun May 31 17:10:20 EDT 2020

 mri_nu_correct.mni --no-rescale --i orig.mgz --o orig_nu.mgz --n 1 --proto-iters 1000 --distance 50 


 talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm 

talairach_avi log file is transforms/talairach_avi.log...

 cp transforms/talairach.auto.xfm transforms/talairach.xfm 

#--------------------------------------------
#@# Talairach Failure Detection Sun May 31 17:11:59 EDT 2020

 talairach_afd -T 0.005 -xfm transforms/talairach.xfm 


 awk -f /opt/freesurfer/bin/extract_talairach_avi_QA.awk /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/la02/mri/transforms/talairach_avi.log 


 tal_QC_AZS /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/la02/mri/transforms/talairach_avi.log 

#--------------------------------------------
#@# Nu Intensity Correction Sun May 31 17:11:59 EDT 2020

 mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --n 2 


 mri_add_xform_to_header -c /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/la02/mri/transforms/talairach.xfm nu.mgz nu.mgz 

#--------------------------------------------
#@# Intensity Normalization Sun May 31 17:14:07 EDT 2020

 mri_normalize -g 1 -mprage nu.mgz T1.mgz 

#--------------------------------------------
#@# Skull Stripping Sun May 31 17:15:56 EDT 2020

 mri_em_register -rusage /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/la02/touch/rusage.mri_em_register.skull.dat -skull nu.mgz /opt/freesurfer/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta 


 mri_watershed -rusage /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/la02/touch/rusage.mri_watershed.dat -T1 -brain_atlas /opt/freesurfer/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta T1.mgz brainmask.auto.mgz 


 cp brainmask.auto.mgz brainmask.mgz 

#-------------------------------------
#@# EM Registration Sun May 31 20:34:18 EDT 2020

 mri_em_register -rusage /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/la02/touch/rusage.mri_em_register.dat -uns 3 -mask brainmask.mgz nu.mgz /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta 

#--------------------------------------
#@# CA Normalize Sun May 31 23:25:44 EDT 2020

 mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta norm.mgz 

#--------------------------------------
#@# CA Reg Sun May 31 23:27:06 EDT 2020

 mri_ca_register -rusage /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/la02/touch/rusage.mri_ca_register.dat -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.m3z 

#--------------------------------------
#@# SubCort Seg Mon Jun  1 01:45:56 EDT 2020

 mri_ca_label -relabel_unlikely 9 .3 -prior 0.5 -align norm.mgz transforms/talairach.m3z /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca aseg.auto_noCCseg.mgz 


 mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/la02/mri/transforms/cc_up.lta la02 

#--------------------------------------
#@# Merge ASeg Mon Jun  1 03:06:10 EDT 2020

 cp aseg.auto.mgz aseg.presurf.mgz 

#--------------------------------------------
#@# Intensity Normalization2 Mon Jun  1 03:06:10 EDT 2020

 mri_normalize -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz 

#--------------------------------------------
#@# Mask BFS Mon Jun  1 03:09:20 EDT 2020

 mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz 

#--------------------------------------------
#@# WM Segmentation Mon Jun  1 03:09:22 EDT 2020

 mri_segment -mprage brain.mgz wm.seg.mgz 


 mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz 


 mri_pretess wm.asegedit.mgz wm norm.mgz wm.mgz 

#--------------------------------------------
#@# Fill Mon Jun  1 03:11:54 EDT 2020

 mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.auto_noCCseg.mgz wm.mgz filled.mgz 

#--------------------------------------------
#@# Tessellate lh Mon Jun  1 03:12:40 EDT 2020

 mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz 


 mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix 


 rm -f ../mri/filled-pretess255.mgz 


 mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix 

#--------------------------------------------
#@# Tessellate rh Mon Jun  1 03:12:45 EDT 2020

 mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz 


 mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix 


 rm -f ../mri/filled-pretess127.mgz 


 mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix 

#--------------------------------------------
#@# Smooth1 lh Mon Jun  1 03:12:51 EDT 2020

 mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix 

#--------------------------------------------
#@# Smooth1 rh Mon Jun  1 03:12:51 EDT 2020

 mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix 

#--------------------------------------------
#@# Inflation1 lh Mon Jun  1 03:13:00 EDT 2020

 mris_inflate -no-save-sulc ../surf/lh.smoothwm.nofix ../surf/lh.inflated.nofix 

#--------------------------------------------
#@# Inflation1 rh Mon Jun  1 03:13:00 EDT 2020

 mris_inflate -no-save-sulc ../surf/rh.smoothwm.nofix ../surf/rh.inflated.nofix 

#--------------------------------------------
#@# QSphere lh Mon Jun  1 03:13:51 EDT 2020

 mris_sphere -q -seed 1234 ../surf/lh.inflated.nofix ../surf/lh.qsphere.nofix 

#--------------------------------------------
#@# QSphere rh Mon Jun  1 03:13:51 EDT 2020

 mris_sphere -q -seed 1234 ../surf/rh.inflated.nofix ../surf/rh.qsphere.nofix 

#--------------------------------------------
#@# Fix Topology Copy lh Mon Jun  1 03:18:12 EDT 2020

 cp ../surf/lh.orig.nofix ../surf/lh.orig 


 cp ../surf/lh.inflated.nofix ../surf/lh.inflated 

#--------------------------------------------
#@# Fix Topology Copy rh Mon Jun  1 03:18:13 EDT 2020

 cp ../surf/rh.orig.nofix ../surf/rh.orig 


 cp ../surf/rh.inflated.nofix ../surf/rh.inflated 

#@# Fix Topology lh Mon Jun  1 03:18:13 EDT 2020

 mris_fix_topology -rusage /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/la02/touch/rusage.mris_fix_topology.lh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 la02 lh 

#@# Fix Topology rh Mon Jun  1 03:18:13 EDT 2020

 mris_fix_topology -rusage /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/la02/touch/rusage.mris_fix_topology.rh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 la02 rh 


 mris_euler_number ../surf/lh.orig 


 mris_euler_number ../surf/rh.orig 


 mris_remove_intersection ../surf/lh.orig ../surf/lh.orig 


 rm ../surf/lh.inflated 


 mris_remove_intersection ../surf/rh.orig ../surf/rh.orig 


 rm ../surf/rh.inflated 

#--------------------------------------------
#@# Make White Surf lh Mon Jun  1 13:47:32 EDT 2020

 mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -whiteonly -mgz -T1 brain.finalsurfs la02 lh 

#--------------------------------------------
#@# Make White Surf rh Mon Jun  1 13:47:32 EDT 2020

 mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -whiteonly -mgz -T1 brain.finalsurfs la02 rh 

#--------------------------------------------
#@# Smooth2 lh Mon Jun  1 13:51:50 EDT 2020

 mris_smooth -n 3 -nw -seed 1234 ../surf/lh.white.preaparc ../surf/lh.smoothwm 

#--------------------------------------------
#@# Smooth2 rh Mon Jun  1 13:51:50 EDT 2020

 mris_smooth -n 3 -nw -seed 1234 ../surf/rh.white.preaparc ../surf/rh.smoothwm 

#--------------------------------------------
#@# Inflation2 lh Mon Jun  1 13:51:57 EDT 2020

 mris_inflate -rusage /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/la02/touch/rusage.mris_inflate.lh.dat ../surf/lh.smoothwm ../surf/lh.inflated 

#--------------------------------------------
#@# Inflation2 rh Mon Jun  1 13:51:57 EDT 2020

 mris_inflate -rusage /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/la02/touch/rusage.mris_inflate.rh.dat ../surf/rh.smoothwm ../surf/rh.inflated 

#--------------------------------------------
#@# Curv .H and .K lh Mon Jun  1 13:52:40 EDT 2020

 mris_curvature -w lh.white.preaparc 


 mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 lh.inflated 

#--------------------------------------------
#@# Curv .H and .K rh Mon Jun  1 13:52:40 EDT 2020

 mris_curvature -w rh.white.preaparc 


 mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 rh.inflated 


#-----------------------------------------
#@# Curvature Stats lh Mon Jun  1 13:53:42 EDT 2020

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm la02 lh curv sulc 


#-----------------------------------------
#@# Curvature Stats rh Mon Jun  1 13:53:46 EDT 2020

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm la02 rh curv sulc 

#--------------------------------------------
#@# Sphere lh Mon Jun  1 13:53:50 EDT 2020

 mris_sphere -rusage /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/la02/touch/rusage.mris_sphere.lh.dat -seed 1234 ../surf/lh.inflated ../surf/lh.sphere 

#--------------------------------------------
#@# Sphere rh Mon Jun  1 13:53:50 EDT 2020

 mris_sphere -rusage /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/la02/touch/rusage.mris_sphere.rh.dat -seed 1234 ../surf/rh.inflated ../surf/rh.sphere 

#--------------------------------------------
#@# Surf Reg lh Mon Jun  1 14:38:53 EDT 2020

 mris_register -curv -rusage /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/la02/touch/rusage.mris_register.lh.dat ../surf/lh.sphere /opt/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/lh.sphere.reg 

#--------------------------------------------
#@# Surf Reg rh Mon Jun  1 14:38:53 EDT 2020

 mris_register -curv -rusage /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/la02/touch/rusage.mris_register.rh.dat ../surf/rh.sphere /opt/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/rh.sphere.reg 

#--------------------------------------------
#@# Jacobian white lh Mon Jun  1 15:58:04 EDT 2020

 mris_jacobian ../surf/lh.white.preaparc ../surf/lh.sphere.reg ../surf/lh.jacobian_white 

#--------------------------------------------
#@# Jacobian white rh Mon Jun  1 15:58:04 EDT 2020

 mris_jacobian ../surf/rh.white.preaparc ../surf/rh.sphere.reg ../surf/rh.jacobian_white 

#--------------------------------------------
#@# AvgCurv lh Mon Jun  1 15:58:06 EDT 2020

 mrisp_paint -a 5 /opt/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/lh.sphere.reg ../surf/lh.avg_curv 

#--------------------------------------------
#@# AvgCurv rh Mon Jun  1 15:58:06 EDT 2020

 mrisp_paint -a 5 /opt/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/rh.sphere.reg ../surf/rh.avg_curv 

#-----------------------------------------
#@# Cortical Parc lh Mon Jun  1 15:58:08 EDT 2020

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 la02 lh ../surf/lh.sphere.reg /opt/freesurfer/average/lh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.annot 

#-----------------------------------------
#@# Cortical Parc rh Mon Jun  1 15:58:08 EDT 2020

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 la02 rh ../surf/rh.sphere.reg /opt/freesurfer/average/rh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.annot 

#--------------------------------------------
#@# Make Pial Surf lh Mon Jun  1 15:58:19 EDT 2020

 mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs la02 lh 

#--------------------------------------------
#@# Make Pial Surf rh Mon Jun  1 15:58:19 EDT 2020

 mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs la02 rh 

#--------------------------------------------
#@# Surf Volume lh Mon Jun  1 16:09:22 EDT 2020
#--------------------------------------------
#@# Surf Volume rh Mon Jun  1 16:09:25 EDT 2020
#--------------------------------------------
#@# Cortical ribbon mask Mon Jun  1 16:09:28 EDT 2020

 mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon la02 

#-----------------------------------------
#@# Parcellation Stats lh Mon Jun  1 16:22:20 EDT 2020

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab la02 lh white 


 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.pial.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab la02 lh pial 

#-----------------------------------------
#@# Parcellation Stats rh Mon Jun  1 16:22:20 EDT 2020

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab la02 rh white 


 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.pial.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab la02 rh pial 

#-----------------------------------------
#@# Cortical Parc 2 lh Mon Jun  1 16:23:08 EDT 2020

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 la02 lh ../surf/lh.sphere.reg /opt/freesurfer/average/lh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.a2009s.annot 

#-----------------------------------------
#@# Cortical Parc 2 rh Mon Jun  1 16:23:08 EDT 2020

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 la02 rh ../surf/rh.sphere.reg /opt/freesurfer/average/rh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.a2009s.annot 

#-----------------------------------------
#@# Parcellation Stats 2 lh Mon Jun  1 16:23:23 EDT 2020

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.a2009s.stats -b -a ../label/lh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab la02 lh white 

#-----------------------------------------
#@# Parcellation Stats 2 rh Mon Jun  1 16:23:23 EDT 2020

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.a2009s.stats -b -a ../label/rh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab la02 rh white 

#-----------------------------------------
#@# Cortical Parc 3 lh Mon Jun  1 16:23:53 EDT 2020

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 la02 lh ../surf/lh.sphere.reg /opt/freesurfer/average/lh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.DKTatlas.annot 

#-----------------------------------------
#@# Cortical Parc 3 rh Mon Jun  1 16:23:53 EDT 2020

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 la02 rh ../surf/rh.sphere.reg /opt/freesurfer/average/rh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.DKTatlas.annot 

#-----------------------------------------
#@# Parcellation Stats 3 lh Mon Jun  1 16:24:04 EDT 2020

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.DKTatlas.stats -b -a ../label/lh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab la02 lh white 

#-----------------------------------------
#@# Parcellation Stats 3 rh Mon Jun  1 16:24:04 EDT 2020

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.DKTatlas.stats -b -a ../label/rh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab la02 rh white 

#-----------------------------------------
#@# WM/GM Contrast lh Mon Jun  1 16:25:01 EDT 2020

 pctsurfcon --s la02 --lh-only 

#-----------------------------------------
#@# WM/GM Contrast rh Mon Jun  1 16:25:01 EDT 2020

 pctsurfcon --s la02 --rh-only 

#-----------------------------------------
#@# Relabel Hypointensities Mon Jun  1 16:25:10 EDT 2020

 mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz 

#-----------------------------------------
#@# AParc-to-ASeg aparc Mon Jun  1 16:25:52 EDT 2020

 mri_aparc2aseg --s la02 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt 

#-----------------------------------------
#@# AParc-to-ASeg a2009s Mon Jun  1 16:25:52 EDT 2020

 mri_aparc2aseg --s la02 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --a2009s 

#-----------------------------------------
#@# AParc-to-ASeg DKTatlas Mon Jun  1 16:25:52 EDT 2020

 mri_aparc2aseg --s la02 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --annot aparc.DKTatlas --o mri/aparc.DKTatlas+aseg.mgz 

#-----------------------------------------
#@# APas-to-ASeg Mon Jun  1 16:33:14 EDT 2020

 apas2aseg --i aparc+aseg.mgz --o aseg.mgz 

#--------------------------------------------
#@# ASeg Stats Mon Jun  1 16:33:23 EDT 2020

 mri_segstats --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /opt/freesurfer/ASegStatsLUT.txt --subject la02 

#-----------------------------------------
#@# WMParc Mon Jun  1 16:34:29 EDT 2020

 mri_aparc2aseg --s la02 --labelwm --hypo-as-wm --rip-unknown --volmask --o mri/wmparc.mgz --ctxseg aparc+aseg.mgz 


 mri_segstats --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject la02 --surf-wm-vol --ctab /opt/freesurfer/WMParcStatsLUT.txt --etiv 

#--------------------------------------------
#@# BA_exvivo Labels lh Mon Jun  1 16:44:17 EDT 2020

 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/lh.BA1_exvivo.label --trgsubject la02 --trglabel ./lh.BA1_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/lh.BA2_exvivo.label --trgsubject la02 --trglabel ./lh.BA2_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/lh.BA3a_exvivo.label --trgsubject la02 --trglabel ./lh.BA3a_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/lh.BA3b_exvivo.label --trgsubject la02 --trglabel ./lh.BA3b_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/lh.BA4a_exvivo.label --trgsubject la02 --trglabel ./lh.BA4a_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/lh.BA4p_exvivo.label --trgsubject la02 --trglabel ./lh.BA4p_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/lh.BA6_exvivo.label --trgsubject la02 --trglabel ./lh.BA6_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/lh.BA44_exvivo.label --trgsubject la02 --trglabel ./lh.BA44_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/lh.BA45_exvivo.label --trgsubject la02 --trglabel ./lh.BA45_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/lh.V1_exvivo.label --trgsubject la02 --trglabel ./lh.V1_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/lh.V2_exvivo.label --trgsubject la02 --trglabel ./lh.V2_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/lh.MT_exvivo.label --trgsubject la02 --trglabel ./lh.MT_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/lh.entorhinal_exvivo.label --trgsubject la02 --trglabel ./lh.entorhinal_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/lh.perirhinal_exvivo.label --trgsubject la02 --trglabel ./lh.perirhinal_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/lh.BA1_exvivo.thresh.label --trgsubject la02 --trglabel ./lh.BA1_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/lh.BA2_exvivo.thresh.label --trgsubject la02 --trglabel ./lh.BA2_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/lh.BA3a_exvivo.thresh.label --trgsubject la02 --trglabel ./lh.BA3a_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/lh.BA3b_exvivo.thresh.label --trgsubject la02 --trglabel ./lh.BA3b_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/lh.BA4a_exvivo.thresh.label --trgsubject la02 --trglabel ./lh.BA4a_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/lh.BA4p_exvivo.thresh.label --trgsubject la02 --trglabel ./lh.BA4p_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/lh.BA6_exvivo.thresh.label --trgsubject la02 --trglabel ./lh.BA6_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/lh.BA44_exvivo.thresh.label --trgsubject la02 --trglabel ./lh.BA44_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/lh.BA45_exvivo.thresh.label --trgsubject la02 --trglabel ./lh.BA45_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/lh.V1_exvivo.thresh.label --trgsubject la02 --trglabel ./lh.V1_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/lh.V2_exvivo.thresh.label --trgsubject la02 --trglabel ./lh.V2_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/lh.MT_exvivo.thresh.label --trgsubject la02 --trglabel ./lh.MT_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/lh.entorhinal_exvivo.thresh.label --trgsubject la02 --trglabel ./lh.entorhinal_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/lh.perirhinal_exvivo.thresh.label --trgsubject la02 --trglabel ./lh.perirhinal_exvivo.thresh.label --hemi lh --regmethod surface 


 mris_label2annot --s la02 --hemi lh --ctab /opt/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.label --l lh.BA2_exvivo.label --l lh.BA3a_exvivo.label --l lh.BA3b_exvivo.label --l lh.BA4a_exvivo.label --l lh.BA4p_exvivo.label --l lh.BA6_exvivo.label --l lh.BA44_exvivo.label --l lh.BA45_exvivo.label --l lh.V1_exvivo.label --l lh.V2_exvivo.label --l lh.MT_exvivo.label --l lh.entorhinal_exvivo.label --l lh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose 


 mris_label2annot --s la02 --hemi lh --ctab /opt/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.thresh.label --l lh.BA2_exvivo.thresh.label --l lh.BA3a_exvivo.thresh.label --l lh.BA3b_exvivo.thresh.label --l lh.BA4a_exvivo.thresh.label --l lh.BA4p_exvivo.thresh.label --l lh.BA6_exvivo.thresh.label --l lh.BA44_exvivo.thresh.label --l lh.BA45_exvivo.thresh.label --l lh.V1_exvivo.thresh.label --l lh.V2_exvivo.thresh.label --l lh.MT_exvivo.thresh.label --l lh.entorhinal_exvivo.thresh.label --l lh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose 


 mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.stats -b -a ./lh.BA_exvivo.annot -c ./BA_exvivo.ctab la02 lh white 


 mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.thresh.stats -b -a ./lh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab la02 lh white 

#--------------------------------------------
#@# BA_exvivo Labels rh Mon Jun  1 16:46:53 EDT 2020

 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/rh.BA1_exvivo.label --trgsubject la02 --trglabel ./rh.BA1_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/rh.BA2_exvivo.label --trgsubject la02 --trglabel ./rh.BA2_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/rh.BA3a_exvivo.label --trgsubject la02 --trglabel ./rh.BA3a_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/rh.BA3b_exvivo.label --trgsubject la02 --trglabel ./rh.BA3b_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/rh.BA4a_exvivo.label --trgsubject la02 --trglabel ./rh.BA4a_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/rh.BA4p_exvivo.label --trgsubject la02 --trglabel ./rh.BA4p_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/rh.BA6_exvivo.label --trgsubject la02 --trglabel ./rh.BA6_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/rh.BA44_exvivo.label --trgsubject la02 --trglabel ./rh.BA44_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/rh.BA45_exvivo.label --trgsubject la02 --trglabel ./rh.BA45_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/rh.V1_exvivo.label --trgsubject la02 --trglabel ./rh.V1_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/rh.V2_exvivo.label --trgsubject la02 --trglabel ./rh.V2_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/rh.MT_exvivo.label --trgsubject la02 --trglabel ./rh.MT_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/rh.entorhinal_exvivo.label --trgsubject la02 --trglabel ./rh.entorhinal_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/rh.perirhinal_exvivo.label --trgsubject la02 --trglabel ./rh.perirhinal_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/rh.BA1_exvivo.thresh.label --trgsubject la02 --trglabel ./rh.BA1_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/rh.BA2_exvivo.thresh.label --trgsubject la02 --trglabel ./rh.BA2_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/rh.BA3a_exvivo.thresh.label --trgsubject la02 --trglabel ./rh.BA3a_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/rh.BA3b_exvivo.thresh.label --trgsubject la02 --trglabel ./rh.BA3b_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/rh.BA4a_exvivo.thresh.label --trgsubject la02 --trglabel ./rh.BA4a_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/rh.BA4p_exvivo.thresh.label --trgsubject la02 --trglabel ./rh.BA4p_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/rh.BA6_exvivo.thresh.label --trgsubject la02 --trglabel ./rh.BA6_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/rh.BA44_exvivo.thresh.label --trgsubject la02 --trglabel ./rh.BA44_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/rh.BA45_exvivo.thresh.label --trgsubject la02 --trglabel ./rh.BA45_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/rh.V1_exvivo.thresh.label --trgsubject la02 --trglabel ./rh.V1_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/rh.V2_exvivo.thresh.label --trgsubject la02 --trglabel ./rh.V2_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/rh.MT_exvivo.thresh.label --trgsubject la02 --trglabel ./rh.MT_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/rh.entorhinal_exvivo.thresh.label --trgsubject la02 --trglabel ./rh.entorhinal_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/adam2392/hdd2/Dropbox/epilepsy_bids/derivatives/freesurfer/fsaverage/label/rh.perirhinal_exvivo.thresh.label --trgsubject la02 --trglabel ./rh.perirhinal_exvivo.thresh.label --hemi rh --regmethod surface 


 mris_label2annot --s la02 --hemi rh --ctab /opt/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.label --l rh.BA2_exvivo.label --l rh.BA3a_exvivo.label --l rh.BA3b_exvivo.label --l rh.BA4a_exvivo.label --l rh.BA4p_exvivo.label --l rh.BA6_exvivo.label --l rh.BA44_exvivo.label --l rh.BA45_exvivo.label --l rh.V1_exvivo.label --l rh.V2_exvivo.label --l rh.MT_exvivo.label --l rh.entorhinal_exvivo.label --l rh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose 


 mris_label2annot --s la02 --hemi rh --ctab /opt/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.thresh.label --l rh.BA2_exvivo.thresh.label --l rh.BA3a_exvivo.thresh.label --l rh.BA3b_exvivo.thresh.label --l rh.BA4a_exvivo.thresh.label --l rh.BA4p_exvivo.thresh.label --l rh.BA6_exvivo.thresh.label --l rh.BA44_exvivo.thresh.label --l rh.BA45_exvivo.thresh.label --l rh.V1_exvivo.thresh.label --l rh.V2_exvivo.thresh.label --l rh.MT_exvivo.thresh.label --l rh.entorhinal_exvivo.thresh.label --l rh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose 


 mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.stats -b -a ./rh.BA_exvivo.annot -c ./BA_exvivo.ctab la02 rh white 


 mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.thresh.stats -b -a ./rh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab la02 rh white 

