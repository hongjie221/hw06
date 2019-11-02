#!/bin/sh

export MIX_ENV=prod
export PORT=5001
export DATABASE_URL="ecto://timesheet:password@localhost/timesheet_prod"
export SECRET_KEY_BASE="FFdiiImj/C7SCsz9Ge9wK6MyD0hKMuUb5O7gfquIyu76aRlHNbwBcwGh10+IX4OT"