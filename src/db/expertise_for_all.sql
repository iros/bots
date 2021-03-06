WITH latest_expertise_log AS (
  SELECT employee_id, expertise_id, MAX(created_at) AS latest
  FROM employee_expertise
  WHERE expertise_id=?
  GROUP BY employee_id, expertise_id
)
SELECT
  (ee.interest_rating * 100) + ee.experience_rating AS weight,
  ARRAY[ee.interest_rating, ee.experience_rating] AS interest_experience,
  STRING_AGG(e.first||' '||e.last, ', ' ORDER BY e.last, e.first) AS employees
FROM latest_expertise_log lel
INNER JOIN employee_expertise ee ON
  ee.employee_id=lel.employee_id AND
  ee.expertise_id=lel.expertise_id AND
  created_at=lel.latest
INNER JOIN employee e ON e.id=ee.employee_id
GROUP BY interest_experience, weight
