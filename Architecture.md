# Architecture for DCTRL operating system.

The following proposal is a services level architecture for running DCTRL. It takes some of the components we have already eg Taylor's btc-vending-machine (payment,price & payout Layers) and my membermail service (essentially MemberData & MemberMail). Uniting them across (possibly hostile) networks with a pub/sub message bus (SubscriptionMgr); this could be low-level (0MQ/MQTT) or alternatively a REST API.

## Components

 - MemberData:       Database wrapper/ORM for inputting new members and querying the immutable member data.
 - BusinessData:     Database wrapper/ORM for business logic, prices, policies etc.
 - Reporter:         Scheduled, State generator for mutuable member data, Generates Business reports eg. monthly income, member active status, balance status or sub-group membership.
 - MemberMail:       Scheduled transactional mailer fetching data from both MemberData and Reporter.
 - ChainNotifier:    Interface to listen for blockchain events and trigger internal calls to SubscriptionMgr.
 - PriceNotifier:    Interface to listen/poll for blockchain exchange rates.
 - MachineNotifier:  Listens to hardware events and sends data to SubscriptionMgr.
 - SubsciptionMgr:   Manages event Pub/Sub. Checks token validity. listen to eg. ChainNotifier and amplify calls to relevant subscriber list.
 - AuthProxy:        Proxy module to decorate outbound messages with proper tokens, request renewals if required and check inbound tokens/signatures.
 - BusinessMgr:      Subscribe to all the Data stores and Notifiers. Applies business logic to execute calls to MachineMgr if appropriate eg. trigger vending or payouts.
 - MachineMgr:       Runs on vending machines. Verifies calls from BusinessMgr, Executes local script to actuate hardware, GPIOs etc.
 - PayoutMgr:        Human-in-the-loop transaction generator, responds to BusinessMgr and generates withdrawal/payment transactions that need additional copayer sign-off.
 - EventLogger:      Subscribe to all channels of SubscriptionMgr, log events to disk.
 - Server:           Serve reports and logs via REST, handle routes.
 - Vault:            Store sensitive data, issue & renew tokens. Used by SubscriptionMgr to verify subscriptions requests have proper ACLs.


## Optional components

 - ChainAdaptor:    Abstract away the differences in blockchain data providers, including full nodes. Provide a unified API.
