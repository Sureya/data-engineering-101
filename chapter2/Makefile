guard-%:
	@ if [ "${${*}}" = "" ]; then echo "Environment variable $* not set"; exit 1; fi

export ENV					?= dev
export API_KEY				?= 432725751d6400d23f3652784b3d5938
export AWS_AUTH_FILE		?= /Users/sureyasathiamoorthi/Desktop/personal-aws/creds/de.pem
export AWS_DEFAULT_REGION  	?= eu-west-2
export AWS_PROFILE         	?= aws-de-lab
export VARS_FILE         	?= vars.env


create-resource:
	cd section-3 ; terraform plan
	cd section-3 ; terraform apply --auto-approve=true

deploy-app:
	@bash test.sh
	source ${VARS_FILE}


cleanup:
	rm -rf deployed


