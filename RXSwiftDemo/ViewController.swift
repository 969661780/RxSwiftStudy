//
//  ViewController.swift
//  RXSwiftDemo
//
//  Created by mt y on 2017/11/8.
//  Copyright © 2017年 mt y. All rights reserved.
//

import UIKit

import RxCocoa

import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //never流
        let disposeBag = DisposeBag()
        let neverSequence = Observable<String>.never()
        let neverSequenceSubscription = neverSequence.subscribe { (event) in
            print("NO Any")
        }.disposed(by: disposeBag)
        //empty流
        let emptySequence = Observable<String>.empty()
        let emptySequencrSubscription = emptySequence.subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
        //just流:创建一种特定的事件
        let justSequence = Observable.just("你好")
        let justSequenceSubscription = justSequence.subscribe { (event) in
            print(event)
        }.addDisposableTo(disposeBag)
        //of 流：创建一个发出多种事件的流
        let ofSequencr = Observable.of("D","D","Y","M","T")
        let ofSequenceSubscription = ofSequencr.subscribe { (evet) in
            print(evet)
        }.addDisposableTo(disposeBag)
        
        let ofSequenceSubscription1 = ofSequencr.subscribe(onNext: { (elent) in
            print(elent)
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            print("haha")
        }) {
            print("xixi")
        }.addDisposableTo(disposeBag)
        //from流：从集合中创建一个流
        let fromSequence = Observable.from(["Y","M","T"])
        let fromSequenceSubscription = fromSequence.subscribe(onNext: { (elent) in
            print(elent)
        }, onError: { (erro) in
            
        }, onCompleted: {
            
        }) {
            
        }.addDisposableTo(disposeBag)
        //create自定义观察sequence,
        let createSequence = {(element:Array<Any>) ->Observable<Array<Any>> in
            return Observable.create({ (observer) -> Disposable in
                observer.onNext(element)
                observer.onCompleted()
                return Disposables.create()
            })
        }
        createSequence(["DDYMT","ddymt"]).subscribe { (event) in
            
            if event.element == nil{
                
            }else{
                   print(event.element![0])
            }
         
            }.disposed(by: disposeBag)
        
        let createSequence1 = Observable<Any>.create { (obsever) -> Disposable in
            obsever.onNext("sss")
            obsever.onCompleted()
            return Disposables.create()
        }
        createSequence1.subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
        //range;range就是创建一个sequence，他会发出这个范围中的从开始到结束的所有事
        let rangSequence = Observable.range(start: 0, count: 10)
        let rangSequenceSubscrible = rangSequence.subscribe { (event) in
            print(event)
            }.disposed(by: disposeBag)
        //repeatElement:创建一个sequence，发出特定事件N次
        let reqeatElementSequence = Observable.repeatElement("wawa").take(3)
        let repeatElentSequencrSubscrible = reqeatElementSequence.subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
        //generate是创建一个可观察的sequence，当初始化的条件为true的时候，他就会发出所对应的事件
        let generateSequence = Observable<Int>.generate(initialState: 6, condition: { (i) -> Bool in
            return i<8
        }) { (j) -> Int in
            return j+1
        }
        let generateSequenceSubscrible = generateSequence.subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
        
      //deferred会为每一为订阅者observer创建一个新的可观察序列
        var count = 1
        
        let deferredSequence = Observable<String>.deferred { () -> Observable<String> in
            count += 1
            print(count)
            return Observable<String>.create({ (observer) -> Disposable in
                
                observer.onNext("deferred")
                return Disposables.create()
            })
        }
        let deferredSequenceSubScrible = deferredSequence.subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
        
     /*
         Subjet是observable和Observer之间的桥梁，一个Subject既是一个Obserable也是一个Observer，他既可以发出事件，也可以监听事件。
         */
        //PublishSubject:只能接受订阅之后的事件
        let subject = PublishSubject<String>()
        subject.subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
       subject.onNext("12")
       subject.onNext("34")
        
        subject.subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
        
        subject.onNext("A")
        subject.onNext("B")
        
        //ReplaySubject:可以接受订阅之前的事件，接受的的事件的个数取决于bufferSize的大小
        
        let mySubject = ReplaySubject<String>.create(bufferSize: 1)
        mySubject.subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
        mySubject.onNext("11")
        mySubject.onNext("22")
        mySubject.subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
        mySubject.onNext("33")
        mySubject.onNext("44")
       
        //BehaviorSubject:会接受到订阅前的最后一个事件
        
        let behaviorSubject = BehaviorSubject.init(value: "A")
        behaviorSubject.subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
        
        behaviorSubject.onNext("B")
        behaviorSubject.onNext("C")
        
        behaviorSubject.subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
        
        /*
         PublishSubject, ReplaySubject和BehaviorSubject是不会自动发出completed事件的。
 
 */
        //Variable:Variable是BehaviorSubject一个包装箱，就像是一个箱子一样，使用的时候需要调用asObservable()拆箱，里面的value是一个BehaviorSubject，他不会发出error事件，但是会自动发出completed事件。
        
        let variable = Variable.init("X")
        variable.asObservable().subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
        variable.value = "Y"
        variable.value = "Z"
        
        variable.asObservable().subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
        variable.value = "MM"
        
        
        //startWith；相当于插入到第一个
        let ofObserable1 = Observable.of("0","1","3").startWith("@@").subscribe { (event) in
            print(event)
            }.disposed(by: disposeBag)
        
        
        
        //merge是合并两个Observable流合成单个Observable流
        Observable.of(behaviorSubject,mySubject).merge().subscribe { (event) in
            print(event)
        }
        
        
        //ZIP绑定超过最多不超过8个的Observable流，结合在一起处理。注意Zip是一个事件对应另一个流一个事件。1对1
        
        let stringSubject = PublishSubject<String>()
        let intSubject = PublishSubject<Int>()
        
        Observable.zip(stringSubject, intSubject) { stringEvelent, intEvelent in
            "\(stringEvelent)\(intEvelent)"
            }.subscribe { (event) in
                print(event)
        }.disposed(by: disposeBag)
        
        stringSubject.onNext("ssss")
        stringSubject.onNext("dddd")
        intSubject.onNext(1)
        intSubject.onNext(2)
        
        //combineLatest是一个流的事件对应另一个流的最新的事件，两个事件都会是最新的事件
        Observable.combineLatest(stringSubject, intSubject) {stringEvent, intEVent in
            "\(stringEvent)\(intEVent)"
            }.subscribe { (event) in
                print(event)
        }.disposed(by: disposeBag)
        
        stringSubject.onNext("oooo")
        stringSubject.onNext("00000")
        intSubject.onNext(12)
        intSubject.onNext(34)
        stringSubject.onNext("9999")
        
        
        //switchLatest可以对事件流进行转换，本来监听的subject1，我可以通过更改variable里面的value更换事件源。变成监听subject2了
        
        Observable<Int>.of(1,2,3).map { (i) -> Int in
            return i * i
            }.subscribe { (event) in
                print(event)
        }.disposed(by: disposeBag)
        //scan就是给一个初始化的数，然后不断的拿前一个结果和最新的值进行处理操作。
        Observable<Int>.of(10,20,30).scan(1) { (agee, new) -> Int in
            agee + new
            }.subscribe { (event) in
                print(event)
        }.disposed(by: disposeBag)
        
        
        //filter很好理解，就是过滤掉某些不符合要求的事件
        Observable.of("1","2","3","4","1","1").filter { (elent) -> Bool in
            return elent == "1"
            }.subscribe { (event) in
                print(event)
        }.disposed(by: disposeBag)
        
        //distinctUntilChanged就是当下一个事件与前一个事件是不同事件的事件才进行处理操作
        Observable.of("1","1","2","3").distinctUntilChanged().subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
        
        //elementAt只处理在指定位置的事件
        Observable.of("1","2","3").elementAt(2).subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
        //single:找出在sequence只发出一次的事件，如果超过一个就会发出error错误
        Observable.of("12","12","34").single { (elent) -> Bool in
            return elent == "34"
            }.subscribe { (event) in
                print(event)
        }.disposed(by: disposeBag)
        
        
        //take:只处理前几个事件信号,
        //takeLast:只处理后几个事件信号
        //takeWhile:当条件满足的时候进行处理
        //takeUntil:接收事件消息，直到另一个sequence发出事件消息的时候
        Observable<Int>.of(1,2,3).takeWhile { (i) -> Bool in
            return i < 3
            }.subscribe { (event) in
                print(event)
        }.disposed(by: disposeBag)
        
        
        //skip:取消前几个事件
        //skipWhile:满足条件的事件消息都取消
        //skipWhileWithIndex；满足条件的都被取消，传入的闭包同skipWhile有点区别而已
        //skipUntil:直到某个sequence发出了事件消息，才开始接收当前sequence发出的事件消息
        
        //toArray:将sequence转换成一个array，并转换成单一事件信号，然后结束
        Observable.range(start: 1, count: 10).toArray().subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
        
        //reduce:用一个初始值，对事件数据进行累计操作。reduce接受一个初始值，和一个操作符号
        Observable<Int>.of(10,100,1000).reduce(1) { (one, two) -> Int in
            return one + two
            }.subscribe { (event) in
                print(event)
        }.disposed(by: disposeBag)
        
        
        //concat:concat会把多个sequence和并为一个sequence，并且当前面一个sequence发出了completed事件，才会开始下一个sequence的事件。
        
        
        /*
         Connectable Observable有订阅时不开始发射事件消息，而是仅当调用它们的connect（）方法时。这样就可以等待所有我们想要的订阅者都已经订阅了以后，再开始发出事件消息，这样能保证我们想要的所有订阅者都能接收到事件消息。其实也就是等大家都就位以后，开始发出消息。

         */
        let intSequence = Observable<Int>.interval(1, scheduler: MainScheduler.instance).publish()
        let intSequenceSubscrible = intSequence.subscribe { (event) in
            print(event)
        }
       
       
        //catchErrorJustReturn
        let sequenceFailes = PublishSubject<String>()
     
        sequenceFailes.catchErrorJustReturn("cuowu").subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
      
        sequenceFailes.onNext("1")
        sequenceFailes.onNext("2")
        sequenceFailes.onNext("23")
        //catchError:捕获error进行处理，可以返回另一个sequence进行订阅
        sequenceFailes.catchError { (error) -> Observable<String> in
            return mySubject
            }.subscribe { (evnt) in
                print(evnt)
        }.disposed(by: disposeBag)
        //retry:遇见error事件可以进行重试，比如网络请求失败，可以进行重新连接
        
        
        
    }
    }


