# New Student Workspace

Use this procedure when the student asks to start the course from zero.

It deletes the previous student's history. Before step 2, list what will be deleted and wait for the student's confirmation.

1. Ask whether to keep the root exercise files (`<n>_<name>.asm`) as reference (recommended) or to remove them for a clean start.
2. Delete the previous student's files:
   - everything in `teacher/memory/`;
   - everything in `teacher/lessons/`;
   - everything in `quiz/`;
   - the root exercise files, only if the student chose the clean start.
3. Reset `teacher/course/course-progress.md`: keep the title, the header and the score legend, remove all concepts.
4. Regenerate `teacher/course/course-plan.md` as a fresh course blueprint, using `argument` from `config.yaml` as the course goal and `language` as the language.
5. Write a new `teacher/memory/current.md`: no exercise completed, next step is the first module of the plan.
6. Offer to commit.
