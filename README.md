mosespa
=======

[![gem version](https://badge.fury.io/rb/mosespa.png)](http://badge.fury.io/rb/mosespa)
[![dependency status](https://gemnasium.com/kamaradclimber/mosespa.png)](https://gemnasium.com/kamaradclimber/mosespa)

mosespa is very small lib on top of jira-ruby gem to interact with jira on command-line.
This uses the REST interface of jira.

Basic command includes :
- ```show TICKET [--verbose]```
- ```comment TICKET a free text comment```
- ```create PROJECT```
- ```browse TICKET```
- ```search a jql research```

Usage
--------

### Basics

If you want to see information about a ticket:

```mosespa --url 'http://jira.myjira.com' --login me.myname --password 'my#"«"$funnypassowrd' show COOK-2878```

If you want to avoid retyping the same basic information, you can have a ```.mosespa``` file in your $HOME in yaml syntax:

```
url: http://jira.myjira.com
login: me.myname
password: my#"«"$funnypassowrd
```

and simply type: ```mosespa show COOK-2878```

To see more information such as comments : ```mosespa show COOK-2878 --verbose```

### Comments

To add a comment:
```mosespa comment COOK-2878 It does not merge properly can you rebase```

If some characters aren't nice to bash:
```mosespa comment COOK-2878 "It does not merge properly, could you rebase?"```

### Creating tickets

To create tickets:
```mosespa create COOK  --summary "Implement special feature" --description "We should have such a thing"```

If you don't specify the summary option (```mosespa create COOK```), mosespa will open you favorite $EDITOR to help you create a new ticket.

### Browsing

If mosespa did not help you, you can launch your $BROWSER on a ticket page with:
```mosespa browse COOK-2878```

###Search

To search for any jql:

```mosespa search 'reporter in (currentUser())'```

Installation
------------

##### From rubygem.org
gem install mosespa


#### From source
Clone this repository, ```gem build mosespa.gemspec``` and ```gem install mosespa*gem```

NB:
If you want (very) basic bash completion (on sub commands only for now), you can include completion_mosespa file in your .bashrc.
Contributions are welcomed on that too !
