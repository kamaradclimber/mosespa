mosespa
=======

mosespa is very small lib on top of jira-ruby gem to interact with jira on command-line.
This uses the REST interface of jira.

Basic command includes :
- ```show TICKET [--verbose]```
- ```comment TICKET a free text comment```
- ``` create PROJECT```

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

If some characters are nice to bash:
```mosespa comment COOK-2878 "It does not merge properly, could you rebase?"```

### Creating tickets

To create tickets:
```mosespa create COOK  --summary "Implement special feature" --description "We should have such a thing"```

If you don't specify the summary option (```mosespa create COOK```), mosespa will open you favorite $EDITOR to help you create a new ticket.


Installation
------------

Clone this repository, ```gem build mosespa.gemspec``` and ```gem install mosespa*gem```