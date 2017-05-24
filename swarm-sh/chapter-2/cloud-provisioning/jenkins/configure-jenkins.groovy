// "There is no good API to help us automate the process"
// regarding the ability to configure Jenkins programmatically.
// Jenkins can be configured through Groovy scripts.
// For example to create an administrative account you would put the
// following script into /usr/share/jenkins/ref/init.groovy.d/createAdminAccount.groovy :

import jenkins.model.*
import hudson.security.*

def username=System.getenv('JENKINS_ADMIN_USERNAME') ?: 'admin'
def password=System.getenv('JENKINS_ADMIN_PASSWORD') ?: 'password'

def instance = Jenkins.getInstance()

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount(username, password)
instance.setSecurityRealm(hudsonRealm)

def strategy = new hudson.security.FullControlOnceLoggedInAuthorizationStrategy()
strategy.setAllowAnonymousRead(false)
instance.setAuthorizationStrategy(strategy)

instance.save()