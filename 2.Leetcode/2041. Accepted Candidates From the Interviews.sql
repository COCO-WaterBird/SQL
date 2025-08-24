Select c.Candidate_id
From Rounds R
Left join Candidates C
On r.interview_id = c.interview_id
WHere c.years_of_exp >= 2
Group by r.interview_id
Having sum(r.score) > 15