//
//  ViewController.swift
//  IMD
//
//  Created by Loren Larson on 6/5/17.
//  Copyright © 2017 Loren Larson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var freqTableView: UITableView!

    struct IMDFreq {
        var freqIMD: String
        var freqChannel: String
        var freqOrg1: String
        var freqOrg2: String
    }

    var freqs: [IMDFreq] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        let newfreq = IMDFreq(freqIMD: "5645", freqChannel: "5646", freqOrg1: "5647", freqOrg2: "5648")
//        freqs.append(newfreq)
//        var tester = freqs[0].freqIMD

    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return freqs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.freqTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IMDTableViewCell

        cell.imdFrequency.text = freqs[indexPath.row].freqIMD
        cell.imdFrequency1.text = freqs[indexPath.row].freqOrg1
        cell.imdFrequency2.text = freqs[indexPath.row].freqOrg2

        if freqs[indexPath.row].freqChannel != "" {
            cell.btnChan.isHidden = false
            cell.btnChan.setTitle(freqs[indexPath.row].freqChannel, for: UIControlState.selected)
            cell.btnChan.setTitleColor(.red, for: UIControlState.selected)
            cell.btnChan.isSelected = true
        } else {
            cell.btnChan.isHidden = true
        }

        return cell
    }
    
    @IBAction func processFreq(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        freqs.removeAll()
        processSelectedButtons()

        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.freqTableView.reloadData()
            }
        }
//        freqTableView.reloadData()
    }

    @IBAction func clearFreq(_ sender: UIButton) {
        for case let sview as UIStackView in self.view.subviews {
            for case let sview1 as UIStackView in sview.subviews {
                for case let button as UIButton in sview1.subviews {
                    if button.isSelected {
                        button.isSelected = false
                        button.setTitleColor(.white, for: UIControlState.selected)
                    }
                }
            }
        }

        freqs.removeAll()

        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.freqTableView.reloadData()
            }
        }
//        freqTableView.reloadData()
    }

    func processSelectedButtons() {
        for case let sview as UIStackView in self.view.subviews {
            for case let sview1 as UIStackView in sview.subviews {
                for case let button as UIButton in sview1.subviews {
                    button.setTitleColor(.white, for: UIControlState.selected)
                }
            }
        }

        for case let sview as UIStackView in self.view.subviews {
            for case let sview1 as UIStackView in sview.subviews {
                for case let button as UIButton in sview1.subviews {
                    if button.isSelected {
                        processAllFrequencies(freq: button.tag)
                    }
                }
            }
        }
    }

    func processAllFrequencies(freq: Int) {
        for case let sview as UIStackView in self.view.subviews {
            for case let sview1 as UIStackView in sview.subviews {
                for case let button as UIButton in sview1.subviews {
                    if button.isSelected && freq != button.tag {
                        //if button.isSelected && freq != button.tag && freq < button.tag {
                        determineIMD(freq1: freq, freq2: button.tag)
                    }
                }
            }
        }
    }
    
    func determineIMD(freq1: Int, freq2: Int) {
        let imd1: Int = (freq1 * 2) - freq2
        let imd2: Int = (freq2 * 2) - freq1
        let toleranceMHz: Int = 15

        var imdChan: String = ""

        for case let sview as UIStackView in self.view.subviews {
            for case let sview1 as UIStackView in sview.subviews {
                for case let button as UIButton in sview1.subviews {
                    imdChan = ""

                    if button.isSelected && imd1 > button.tag - toleranceMHz && imd1 < button.tag + toleranceMHz {
                        button.setTitleColor(.red, for: UIControlState.selected)
                        imdChan = String(button.tag)
                        let newfreq1 = IMDFreq(freqIMD: String(imd1), freqChannel: imdChan, freqOrg1: String(freq1), freqOrg2: String(freq2))

                        if !dupCheck(newFreq: newfreq1) {
                            freqs.append(newfreq1)
                      }
                    }
                }
            }
        }

        for case let sview as UIStackView in self.view.subviews {
            for case let sview1 as UIStackView in sview.subviews {
                for case let button as UIButton in sview1.subviews {
                    imdChan = ""

                    if button.isSelected && imd2 > button.tag - toleranceMHz && imd2 < button.tag + toleranceMHz {
                        button.setTitleColor(.red, for: UIControlState.selected)
                        imdChan = String(button.tag)
                        let newfreq2 = IMDFreq(freqIMD: String(imd2), freqChannel: imdChan, freqOrg1: String(freq1), freqOrg2: String(freq2))

                        if !dupCheck(newFreq: newfreq2) {
                            freqs.append(newfreq2)
                        }
                    }
                }
            }
        }
    }

    func dupCheck(newFreq: IMDFreq) -> Bool {
        for item in freqs {
            if (item.freqChannel == newFreq.freqChannel) && (item.freqIMD == newFreq.freqIMD) && (item.freqOrg1 == newFreq.freqOrg1) && (item.freqOrg2 == newFreq.freqOrg2) {
                return true
            }

            if (item.freqChannel == newFreq.freqChannel) && (item.freqIMD == newFreq.freqIMD) && (item.freqOrg1 == newFreq.freqOrg2) && (item.freqOrg2 == newFreq.freqOrg1) {
                return true
            }
        }

        return false
    }
}
