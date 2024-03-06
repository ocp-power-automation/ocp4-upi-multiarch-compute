# ocp4-upi-multiarch-compute

The [`ocp4-upi-multiarch-compute` project](https://github.com/ocp-power-automation/ocp4-upi-multiarch-compute) provides code to facilitate post installation additions of OpenShift Container Platform (OCP) 4.x compute workers on a variety of platforms.

## Documentation
- [Multi-Architecture Compute: Supporting Architecture Specific Operating System and Kernel Parameters](https://community.ibm.com/community/user/powerdeveloper/blogs/chandan-abhyankar/2024/03/06/multi-architecture-compute-supporting-architecture) - isolating multi-arch parameters.

## Design

This code is designed to be modular. The code base favors Ansible, however does accept code in shell and hcl.

## Contributing

If you have any questions or issues you can create a new [issue here][issues].

Pull requests are very welcome! Make sure your patches are well tested.
Ideally create a topic branch for every separate change you make. For
example:

1. Fork the repo
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

All source files must include a Copyright and License header. The SPDX license header is 
preferred because it can be easily scanned.

If you would like to see the detailed LICENSE click [here](LICENSE).

```text
#
# Copyright 2024 - IBM Corporation. All rights reserved
# SPDX-License-Identifier: Apache-2.0
#
```
