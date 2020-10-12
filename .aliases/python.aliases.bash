alias python3='python3.8'
alias pip3='python3.8 -m pip'
alias pip='python2.7 -m pip'


# Pip status using pip-review
# (https://github.com/jgonggrijp/pip-review)
# NOTE: would like to get rid of this dependency at some point
alias preview='pip-review'

# Update all pip packages automatically
alias pupdate='pip-review --auto'

# Update pip packages (step through one-by-one)
alias pupdate_i='pip-review --interactive'