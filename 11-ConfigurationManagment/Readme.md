![Ansible](header_1.png)

## Introduction

Welcome to the Ansible section of the DevStartOps repository!

Ansible is an open-source automation tool used for configuration management, application deployment, and task automation. It allows you to manage your infrastructure as code, making it easier to deploy, manage, and orchestrate systems in a consistent and repeatable way.

## Why Ansible?

Consider a scenario where you need to deploy a new application version across hundreds of servers. Doing this manually would be time-consuming and error-prone. With Ansible, you can write a playbook that automates the deployment process, ensuring that all servers are configured correctly and the application is deployed consistently.

## Key Features

- **Agentless:** Ansible does not require any agent installation on the target machines, using SSH for communication.
- **Idempotent:** Ensures that tasks can be run multiple times without causing unintended changes.
- **Extensible:** Supports a wide range of modules and allows you to create custom modules.
- **Playbooks:** YAML-based files that define automation tasks.
- **Roles:** A way to organize playbooks and share them across multiple projects.

## Essential Concepts

### Playbooks

Playbooks are the core of Ansible's configuration, deployment, and orchestration language. They are simple YAML files that define the tasks to be executed on the managed hosts.

**Example:**

```yaml
# playbook.yml
- name: Install and configure Nginx
  hosts: webservers
  become: yes

  tasks:
    - name: Install Nginx
      apt:
        name: nginx
        state: present

    - name: Start Nginx service
      service:
        name: nginx
        state: started
```

## Essential Concepts

### Inventory

The inventory is a file that defines the hosts and groups of hosts upon which Ansible will operate. It can be a simple text file or dynamically generated.

**Example:**

```ini
# inventory
[webservers]
web1.example.com
web2.example.com

[databases]
db1.example.com
db2.example.com
```

### Roles

Roles are a way to group tasks and variables into reusable components. They allow you to organize your playbooks and share them across multiple projects.

**Example Structure:**

```plaintext
my-role/
├── tasks/
│   └── main.yml
├── handlers/
│   └── main.yml
├── templates/
│   └── nginx.conf.j2
├── files/
└── vars/
    └── main.yml
```

- **tasks/main.yml:** Contains the tasks that will be executed by the role.
- **handlers/main.yml:** Contains handlers that can be triggered by tasks.
- **templates/nginx.conf.j2:** Contains Jinja2 templates for configuration files.
- **files/:** Directory for **static files that can be deployed.
- **vars/main.yml:** Contains variables specific to the role.

### Example Playbook Using a Role:

```yaml
# playbook.yml
- name: Deploy and configure web server
  hosts: webservers
  roles:
    - my-role
```

In this example, the **my-role** role is applied to the webservers group of hosts, and it will use all the components defined in the role's directory structure.

### How to Create a Role:

- Create Role Directory:

```bash
ansible-galaxy init my-role
```
- Define Tasks: Edit tasks/main.yml to include the tasks you want the role to perform.

- Add Handlers: Define any necessary handlers in handlers/main.yml.

- Create Templates: Place any Jinja2 templates in the templates/ directory.

- Add Static Files: Place any static files in the files/ directory.

- Define Variables: Set role-specific variables in vars/main.yml.

### Variables

Variables in Ansible allow you to customize playbook execution. They can be defined in playbooks, inventory files, or passed in at runtime.

**Example:**

```yaml
# playbook.yml
- name: Deploy application
  hosts: webservers
  vars:
    app_version: "1.0.0"
  
  tasks:
    - name: Deploy app version
      shell: "deploy_app.sh {{ app_version }}"
```
### Where Variables Can Be Declared:

- **In playbooks** (vars: section)
- **In inventory files** (vars section)
- **In separate variable files** (vars/main.yml)
- **Passed as command-line arguments** (ansible-playbook playbook.yml -e "app_version=1.0.0")
- **In environment variables**
- **In the group_vars/ directory**
- **In the host_vars/ directory**

### Handlers

Handlers are used to trigger actions at the end of a playbook run, typically in response to changes made during the playbook execution.

```yaml
# playbook.yml
- name: Configure web server
  hosts: webservers

  tasks:
    - name: Update configuration file
      template:
        src: nginx.conf.j2
        dest: /etc/nginx/nginx.conf
      notify:
        - Restart Nginx

  handlers:
    - name: Restart Nginx
      service:
        name: nginx
        state: restarted
```
### Modules

Ansible modules are the building blocks for playbooks. They are small programs that perform specific tasks, such as installing software, copying files, or managing services.

**Example:**

```yaml
# playbook.yml
- name: Manage packages
  hosts: all

  tasks:
    - name: Ensure Nginx is installed
      apt:
        name: nginx
        state: present

    - name: Ensure Nginx is running
      service:
        name: nginx
        state: started
```
### Key Points:

- **Modules:** Modules perform specific tasks and can be used to manage resources.
- **Built-in Modules:** Ansible comes with a large collection of built-in modules.
- **Custom Modules:** You can create custom modules if needed.

### Common Modules:
- **apt:** Manages packages using the apt package manager (Debian-based systems).
- **yum:** Manages packages using the yum package manager (RedHat-based systems).
- **service:** Manages services.
- **copy:** Copies files to remote locations.
- **template:** Manages files based on Jinja2 templates.

### Example Command:

To use a module directly from the command line:

```bash
ansible all -m ping
```

### Tags

Tags allow you to run specific parts of a playbook instead of the entire playbook. This is useful for debugging or rerunning specific tasks.

```yaml
# playbook.yml
- name: Install and configure web server
  hosts: webservers

  tasks:
    - name: Install Nginx
      apt:
        name: nginx
        state: present
      tags: install

    - name: Configure Nginx
      template:
        src: nginx.conf.j2
        dest: /etc/nginx/nginx.conf
      tags: config
```

### Galaxy
Ansible Galaxy is a repository for Ansible roles. You can download and share roles with the Ansible community.

#### Example Command:
```bash
# Install a role from Ansible Galaxy
ansible-galaxy install geerlingguy.nginx
```

### How to Use Ansible
- **Write Playbooks:** Define your automation tasks in YAML files.
- **Create an Inventory:** List the hosts or groups of hosts that Ansible will manage.
- **Run Playbooks:** Use the ansible-playbook command to execute your playbooks.
- **Use Roles:** Organize your playbooks into reusable components with roles.
- **Leverage Ansible Galaxy:** Download and share roles from the Ansible community.

Ansible is a powerful tool for automating your infrastructure management. By integrating Ansible into your DevOps practices, you'll be able to ensure consistency, reduce manual errors, and speed up your deployment processes.

### **Happy Automating!**