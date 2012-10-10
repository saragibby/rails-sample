stage:
	git push staging staging:master
	git push origin staging:staging
	heroku run rake db:migrate --app rails-sample-test
	heroku restart --app rails-sample-test

deploy:
	git push prod prod:master
	git push origin prod:prod
	heroku run rake db:migrate --app rails-sample
	heroku restart --app rails-sample