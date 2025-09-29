# FreeCodeCamp Relational DB Project

# Number Guessing Game

Submission checklist
- number_guess.sh at repo root
- number_guess.sql (DB dump via pg_dump)

How to produce number_guess.sql
- Run inside VM bash terminal (not psql):
  pg_dump -cC --inserts -U freecodecamp number_guess > number_guess.sql
- Then commit and push:
  git add number_guess.sql && git commit -m "chore: add database dump" && git push origin main
