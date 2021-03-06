USE [psyii]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetLatestRestrictiveInterventionRRN]    Script Date: 22/11/2019 13:40:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
---------------------------------------------------------------------------------------

alter PROCEDURE [dbo].[sp_GetLatestClientRestrictiveInterventionRRN]
(
	@clientid int = null
)
AS 
/*****************************************************
 Test SP for Restrictive Interventions summary
 RRN 21/01/2020 
 Version 2 to use new data model

exec dbo.sp_GetLatestClientRestrictiveInterventionRRN 365662
exec dbo.sp_GetLatestClientRestrictiveInterventionRRN 365663
*****************************************************/

select top 1 
 ce.ceid
,cec.cericid
,ce.episodeid
,ce.careplanid
,ce.eventType
,cec.RIType
,cec.RISubType
,isnull(convert(varchar,ce.RIstartDate,120),'')					        as RIstartDate
,isnull(convert(varchar,ce.RIendDate,120),'')						    as RIendDate
,isnull(convert(varchar,cec.startdate,120),'')						    as componentstart
,isnull(convert(varchar,cec.enddate,120),'')						    as componentend
,isnull(convert(varchar,cec.doctorinformed,120),'')						as doctorInformed
,isnull(convert(varchar,cec.doctorattended,120),'')						as doctorAttended
,isnull(convert(varchar,ce.postincidentreview,120),'')					as postincidentreview
,isnull(convert(varchar,cec.RelativeInformedDT,120),'')				    as relativeInformed
,isnull(convert(varchar,cec.NursingReviewDT,120),'')				    as [nursingReviewDT]
,isnull(convert(varchar,dateadd(hh,2,cec.NursingReviewDT),120),'')		as [nursingReviewNextDueDT]
,isnull(convert(varchar,cec.MedReviewDT,120),'')						as [medicalReviewDT]
,isnull(convert(varchar,dateadd(hh,isnull(cec.MedReviewFreq,0),cec.MedReviewDT),120),'') as [medicalReviewNextDueDT]
,isnull(convert(varchar,cec.MDTReviewDT,120),'')						as [mdtReviewDT]
,isnull(convert(varchar,dateadd(hh,24,cec.MDTReviewDT),120),'')			as [mdtReviewNextDueDT]
,isnull(convert(varchar,cec.IndependentReviewDT,120),'')				as [independentReviewDT]
,isnull(convert(varchar,dateadd(hh,8,cec.IndependentReviewDT),120),'')	as [independentReviewNextDueDT]
,isnull(convert(varchar,cec.PIReviewDT,120),'')							as [piReviewDT]
,isnull(cec.OfferedPI,0)												as [progress]
,isnull(convert(varchar,dateadd(hh,72,cec.DateandTimeofI),120),'')	    as [due]
,isnull(convert(varchar,cec.PhysicalObservationsEndDT,120),'')		    as [physicalobservationsend]
,cec.HRMBNF																as [HRMBNF]
,cec.HRMPEHP															as [HRMPEHP]
,cec.HRMASA																as [HRMASA]
,cec.HRMHDRI															as [HRMHDRI]
,isnull(cec.MedReviewFreq,0)											as [medreviewfreq]
,isnull(cec.SNR,0)														as [SNR]
,isnull(cec.SMR,0)														as [SMR]
,isnull(cec.SMDR,0)														as [SMDTR]
,isnull(cec.SIR,0)														as [SIR]
,cast(isnull(cec.Notes,'') as varchar(max))								as [note]
,'' /* isnull(n.Score,'') */											as [news2score]
,'' /* isnull(convert(varchar,n.DateCreated,120),'') */					as [news2date]
,'' /* isnull(convert(varchar,dateadd(hh,isnull(nfb.FequencyHours,0),n.DateCreated),120),'') */ as [nextnews2]
,isnull(ce.StaffInjured,0)												as [staffinjured]
,isnull(ce.PatientInjured,0)											as [patientinjured]
,sg.Description															as [team]

from dbo.tblClientEventRRN ce
join dbo.tblClientEventRIComponentRRN cec	on ce.ceid = cec.ceid
join dbo.cpacareplan cpa					on ce.CarePlanID = cpa.CarePlanID
join dbo.servgrp sg							on cpa.Team = sg.[Service Code]

--left join dbo.News n						on cpa.ClientID = n.ClientID
--											and cpa.EpisodeID = n.EpisodeID
--											and cpa.CarePlanID = n.CarePlanID
--left join dbo.NewsFeedback nfb				on n.FeedbackID= nfb.id

where ce.clientid = @clientid
and cec.RIType = 1 -- seclusion
and ce.postincidentreview is null

union

select top 1 
 ce.ceid
,cec.cericid
,ce.episodeid
,ce.careplanid
,ce.eventType
,cec.RIType
,cec.RISubType
,isnull(convert(varchar,ce.RIstartDate,120),'')					        as RIstartDate
,isnull(convert(varchar,ce.RIendDate,120),'')						    as RIendDate
,isnull(convert(varchar,cec.startdate,120),'')						    as componentstart
,isnull(convert(varchar,cec.enddate,120),'')						    as componentend
,isnull(convert(varchar,cec.doctorinformed,120),'')						as doctorInformed
,isnull(convert(varchar,cec.doctorattended,120),'')						as doctorAttended
,isnull(convert(varchar,ce.postincidentreview,120),'')					as postincidentreview
,isnull(convert(varchar,cec.RelativeInformedDT,120),'')				    as relativeInformed
,isnull(convert(varchar,cec.NursingReviewDT,120),'')				    as [nursingReviewDT]
,isnull(convert(varchar,dateadd(hh,2,cec.NursingReviewDT),120),'')		as [nursingReviewNextDueDT]
,isnull(convert(varchar,cec.MedReviewDT,120),'')						as [medicalReviewDT]
,isnull(convert(varchar,dateadd(hh,isnull(cec.MedReviewFreq,0),cec.MedReviewDT),120),'') as [medicalReviewNextDueDT]
,isnull(convert(varchar,cec.MDTReviewDT,120),'')						as [mdtReviewDT]
,isnull(convert(varchar,dateadd(hh,24,cec.MDTReviewDT),120),'')			as [mdtReviewNextDueDT]
,isnull(convert(varchar,cec.IndependentReviewDT,120),'')				as [independentReviewDT]
,isnull(convert(varchar,dateadd(hh,8,cec.IndependentReviewDT),120),'')	as [independentReviewNextDueDT]
,isnull(convert(varchar,cec.PIReviewDT,120),'')							as [piReviewDT]
,isnull(cec.OfferedPI,0)												as [progress]
,isnull(convert(varchar,dateadd(hh,72,cec.DateandTimeofI),120),'')	    as [due]
,isnull(convert(varchar,cec.PhysicalObservationsEndDT,120),'')		    as [physicalobservationsend]
,cec.HRMBNF																as [HRMBNF]
,cec.HRMPEHP															as [HRMPEHP]
,cec.HRMASA																as [HRMASA]
,cec.HRMHDRI															as [HRMHDRI]
,isnull(cec.MedReviewFreq,0)											as [medreviewfreq]
,isnull(cec.SNR,0)														as [SNR]
,isnull(cec.SMR,0)														as [SMR]
,isnull(cec.SMDR,0)														as [SMDTR]
,isnull(cec.SIR,0)														as [SIR]
,cast(isnull(cec.Notes,'') as varchar(max))								as [note]
,'' /* isnull(n.Score,'') */											as [news2score]
,'' /* isnull(convert(varchar,n.DateCreated,120),'') */					as [news2date]
,'' /* isnull(convert(varchar,dateadd(hh,isnull(nfb.FequencyHours,0),n.DateCreated),120),'') */ as [nextnews2]
,isnull(ce.StaffInjured,0)												as [staffinjured]
,isnull(ce.PatientInjured,0)											as [patientinjured]
,sg.Description															as [team]

from dbo.tblClientEventRRN ce
join dbo.tblClientEventRIComponentRRN cec	on ce.ceid = cec.ceid
join dbo.cpacareplan cpa					on ce.CarePlanID = cpa.CarePlanID
join dbo.servgrp sg							on cpa.Team = sg.[Service Code]
--left join dbo.News n						on cpa.ClientID = n.ClientID
--											and cpa.EpisodeID = n.EpisodeID
--											and cpa.CarePlanID = n.CarePlanID
--left join dbo.NewsFeedback nfb				on n.FeedbackID= nfb.id
where ce.clientid = @clientid
and cec.RIType = 2 -- Rapid Trans
and ce.postincidentreview is null

union

select top 1 
 ce.ceid
,cec.cericid
,ce.episodeid
,ce.careplanid
,ce.eventType
,cec.RIType
,cec.RISubType
,isnull(convert(varchar,ce.RIstartDate,120),'')					        as RIstartDate
,isnull(convert(varchar,ce.RIendDate,120),'')						    as RIendDate
,isnull(convert(varchar,cec.startdate,120),'')						    as componentstart
,isnull(convert(varchar,cec.enddate,120),'')						    as componentend
,isnull(convert(varchar,cec.doctorinformed,120),'')						as doctorInformed
,isnull(convert(varchar,cec.doctorattended,120),'')						as doctorAttended
,isnull(convert(varchar,ce.postincidentreview,120),'')					as postincidentreview
,isnull(convert(varchar,cec.RelativeInformedDT,120),'')				    as relativeInformed
,isnull(convert(varchar,cec.NursingReviewDT,120),'')				    as [nursingReviewDT]
,isnull(convert(varchar,dateadd(hh,2,cec.NursingReviewDT),120),'')		as [nursingReviewNextDueDT]
,isnull(convert(varchar,cec.MedReviewDT,120),'')						as [medicalReviewDT]
,isnull(convert(varchar,dateadd(hh,isnull(cec.MedReviewFreq,0),cec.MedReviewDT),120),'') as [medicalReviewNextDueDT]
,isnull(convert(varchar,cec.MDTReviewDT,120),'')						as [mdtReviewDT]
,isnull(convert(varchar,dateadd(hh,24,cec.MDTReviewDT),120),'')			as [mdtReviewNextDueDT]
,isnull(convert(varchar,cec.IndependentReviewDT,120),'')				as [independentReviewDT]
,isnull(convert(varchar,dateadd(hh,8,cec.IndependentReviewDT),120),'')	as [independentReviewNextDueDT]
,isnull(convert(varchar,cec.PIReviewDT,120),'')							as [piReviewDT]
,isnull(cec.OfferedPI,0)												as [progress]
,isnull(convert(varchar,dateadd(hh,72,cec.DateandTimeofI),120),'')	    as [due]
,isnull(convert(varchar,cec.PhysicalObservationsEndDT,120),'')		    as [physicalobservationsend]
,cec.HRMBNF																as [HRMBNF]
,cec.HRMPEHP															as [HRMPEHP]
,cec.HRMASA																as [HRMASA]
,cec.HRMHDRI															as [HRMHDRI]
,isnull(cec.MedReviewFreq,0)											as [medreviewfreq]
,isnull(cec.SNR,0)														as [SNR]
,isnull(cec.SMR,0)														as [SMR]
,isnull(cec.SMDR,0)														as [SMDTR]
,isnull(cec.SIR,0)														as [SIR]
,cast(isnull(cec.Notes,'') as varchar(max))								as [note]
,'' /* isnull(n.Score,'') */											as [news2score]
,'' /* isnull(convert(varchar,n.DateCreated,120),'') */					as [news2date]
,'' /* isnull(convert(varchar,dateadd(hh,isnull(nfb.FequencyHours,0),n.DateCreated),120),'') */ as [nextnews2]
,isnull(ce.StaffInjured,0)												as [staffinjured]
,isnull(ce.PatientInjured,0)											as [patientinjured]
,sg.Description															as [team]

from dbo.tblClientEventRRN ce
join dbo.tblClientEventRIComponentRRN cec	on ce.ceid = cec.ceid
join dbo.cpacareplan cpa					on ce.CarePlanID = cpa.CarePlanID
join dbo.servgrp sg							on cpa.Team = sg.[Service Code]
--left join dbo.News n						on cpa.ClientID = n.ClientID
--											and cpa.EpisodeID = n.EpisodeID
--											and cpa.CarePlanID = n.CarePlanID
--left join dbo.NewsFeedback nfb				on n.FeedbackID= nfb.id
where ce.clientid = @clientid
and cec.RIType = 3 -- Physical restraint
and ce.postincidentreview is null
order by componentstart desc



