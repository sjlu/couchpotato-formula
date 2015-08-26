couchpotato:
  git.latest:
    - name: https://github.com/RuudBurger/CouchPotatoServer.git
    - target: /var/www/CouchPotatoServer
    - rev: master
    - submodules: true
    - user: www-data
    - require:
      - pkg: git
 
couchpotato-media-folder:
  file.directory:
    - name: /var/www/media/movies
    - user: www-data
    - group: www-data
    - mode: 755
    - makedirs: True

couchpotato-init:
  file.managed:
    - name: /etc/init.d/couchpotato
    - source: salt://couchpotato/files/ubuntu
    - user: root
    - group: root
    - mode: 755

couchpotato-default:
  file.managed:  
    - name: /etc/default/couchpotato
    - source: salt://couchpotato/files/ubuntu.default
    - user: root
    - group: root
    - mode: 644
    - template: jinja

couchpotato-service:
  service.enabled:
    - name: couchpotato

couchpotato-start:
  cmd.run:
    - name: /etc/init.d/couchpotato start
    - onchanges:
      - file: couchpotato-default

couchpotato-stop:
  cmd.run:
    - name: /etc/init.d/couchpotato stop
    - prereq:
      - file: couchpotato-config

couchpotato-config:
  file.managed:
    - name: /var/www/.couchpotato/settings.conf
    - source: salt://couchpotato/files/settings.conf
    - mode: 644
    - user: www-data
    - group: www-data
    - template: jinja

couchpotato-restart:
  cmd.run:
    - name: /etc/init.d/couchpotato restart
    - onchanges:
      - file: couchpotato-config

