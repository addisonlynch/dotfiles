alias python3='python3.6'
alias pip3='pip3.6'
alias pip='python2.7 -m pip'


# Pip status using pip-review
# (https://github.com/jgonggrijp/pip-review)
# NOTE: would like to get rid of this dependency at some point
alias preview='pip-review'

# Update all pip packages automatically
alias pupdate='pip-review --auto'

# Update pip packages (step through one-by-one)
alias pupdate_i='pip-review --interactive'