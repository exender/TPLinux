# TP 2 Linux Vagrant

## Deploiment simple

Vagrant file config 

```bash 

$script = <<SCRIPT
yum install vim -y
SCRIPT

Vagrant.configure("2")do|config|
  config.vm.box="centos/7"
  config.vm.network "private_network", ip: "192.168.2.11"
  config.vm.hostname = "tp2b2"
  config.vm.provision "shell", inline: $script

 



  # Ajoutez cette ligne afin d'accélérer le démarrage de la VM (si une erreur 'vbguest' est levée, voir la note un peu plus bas)
  config.vbguest.auto_update = false


  # Désactive les updates auto qui peuvent ralentir le lancement de la machine
  config.vm.box_check_update = false


  # La ligne suivante permet de désactiver le montage d'un dossier partagé (ne marche pas tout le temps directement suivant vos OS, versions d'OS, etc.)
  config.vm.synced_folder ".", "/vagrant", disabled: true

config.vm.define :tp2b2 do |t|
end

config.vm.provider "virtualbox" do |v|
        v.memory = 1024
        v.name = "tp2b2"



end

end
```

## 
