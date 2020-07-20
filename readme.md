
# GCP Terraform Module

  

해당 Repository는 손쉽게 사용하기 위해 Terraform으로 Module화하여 공유하고자 한다.
  

## Prepares

  

필요한 사항은 다음과 같다 :

  

**GCP Service Account**

>  - Compute Engine Admin 또는 해당 권한을 포함하고 있는 Service Account

  

**Environment Variables**

기존에는 GOOGLE_APPLICATION_CREDENTIALS를 이용하여 전역변수처럼 선언하였지만, backend가 없는 경우 별도로 전역변수를 선언할 필요가 없으므로 var.credentials만 변수로 선언해준다.
> In Linux OS
>  - export TF_VAR_credentials=/path/to/service/account

> In Windows OS(PowerShell)
>  - $env:TF_VAR_credentials=/path/to/service/account

  
## 사용 방법
모듈 사용 방법은 다음과 같다.

```terraform module
module "vm-with-1disk" {
  source          = "../../0.modules/gce-vm/vm-extip"
  module_enabled  = true
  add_disk        = false
  instance-count  = 1
  project_id      = var.project
  instance-name   = "kcg-vm1"
  machine-type    = "n1-standard-2"
  instance-region = "asia-northeast3"
  cpu_platform    = "Intel Skylake"
  network_tags    = ["internal"]
  subnet-name     = "default"
  image           = "centos-cloud/centos-7"
  disk-type       = "pd-standard"
  disk-size       = "20"
  startup-script = "${file("../stackdriver-agent.sh")}"
  # this is null(garbage)
  disk-type2         = "pd-standard"  # data not applicable
  disk-size2         = "20"           # data not applicable
}
/* outputs.tf는 필요 시 추가
output "instance_1disk_name" {
  value = module.vm-with-1disk.vm1-name[0]
}
output "instance_1disk_ip" {
  value = module.vm-with-1disk.vm1-extip[0]
}
*/
```
```
module "vm-with-2disk" {
  source          = "../../0.modules/gce-vm/vm-extip"
  module_enabled  = true
  add_disk        = true
  instance-count  = 1
  project_id      = var.project
  instance-name   = "kcg-vm2"
  machine-type    = "n1-standard-1"
  instance-region = var.region
  cpu_platform    = "Intel Skylake"
  network_tags    = ["internal"]
  subnet-name     = "default"
  image           = "centos-cloud/centos-7"
  disk-type       = "pd-standard"
  disk-size       = "20"
  startup-script = "${file("../stackdriver-agent.sh")}"
  # second disk
  disk-type2         = "pd-standard"
  disk-size2         = "20"
}
```
`module_enabled` 변수와 `add_disk` 변수의 조합을 통해 디스크를 추가할지 일반 VM을 생성할지 결정하였음.

`instance-count` 변수의 개수대로 동일한 VM이 생성되는 원리로 작성하였음.

_p.s. `vm-with-1disk`에서 disk2를 작성하지만 반영되지 않는다._

## ETC
  
  이번 git commit 시에는 instance with external ip만 작성하였지만, 추후 instance internal도 포함시켜 upgrade 및 다른 GCP resource 또한 점차적으로 추가해 나갈 예정이다.
  어느 정도 추가 완료 시 구성도 또한 포함시킬 예정이다.

단 이후 추가 시 GCP를 할지 다른 클라우드를 할지는 미지수...
  

> Written with [StackEdit](https://stackedit.io/).
