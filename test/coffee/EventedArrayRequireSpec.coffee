define ['eventedarray','underscore'], (EventedArray, _) ->

  enumerable = new EventedArray()

  describe 'EventedArray', ->

    it 'should exist', ->
      expect(enumerable).toBeTruthy()

    it 'should have empty values when initialized empty', ->
      expect(enumerable.values).toEqual([])

    it 'should have empty events when initialized empty', ->
      expect(enumerable.events).toEqual({})

    it 'should have an array of values when initialized with args', ->
      a = new EventedArray(1,2,3)
      b = new EventedArray([1,2,3])
      c = new EventedArray({foo : 1}, 2, [1,2,3], "hi")
      expect(a.values).toEqual([1,2,3])
      expect(b.values).toEqual([[1,2,3]])
      expect(c.values).toEqual([{foo : 1}, 2, [1,2,3], "hi"])

    it 'should provide a JSON string representation with e.toString()', ->
      arr = [1,2,{foo : 'bar'},"koji"]
      a = new EventedArray(arr)
      expect(a.toString()).toEqual(JSON.stringify([arr]))

    it 'should be able to have values set with e.set(n)', ->
      e = new EventedArray()
      e.set(1)
      expect(e.values).toEqual([1])
      e.set("foo")
      expect(e.values).toEqual([1,"foo"])
      e.set({foo : "bar"})
      expect(e.values).toEqual([1,"foo",{foo : "bar"}])
      e.set(100, ['a'])
      expect(e.values).toEqual([1,"foo",{foo : "bar"}, 100, ['a']])

    it 'should return values with e.get(index)', ->
      e = new EventedArray(1,2,3,"akira",[3])
      expect(e.get(0)).toEqual(1)
      expect(e.get(2)).toEqual(3)
      expect(e.get(4)).toEqual([3])

    it 'should pop() values off the end', ->
      e = new EventedArray(1,2,3,4,5)
      c = 0
      while ++c < 5
        e.pop()
        end = 5 - c
        expect(e.values).toEqual([1..end])

    it 'should shift() values off the front and return them', ->
      e = new EventedArray(1,2,3,4,5)
      c = 0
      while ++c < 5
        expect(e.shift()).toEqual(c)
        expect(e.values).toEqual([c+1..5])

    it 'should remove() arbitrary values by match and return it', ->
      e = new EventedArray(1,2,"foo",['a'],{foo : "bar"})
      expect(e.remove("foo")).toEqual("foo")
      expect(e.values).toEqual([1,2,['a'],{foo:"bar"}])

      # Gotcha! Objects are a little different
      expect(e.remove({foo:"bar"})).toEqual(false)

      # We can only remove the same Object reference
      o = { bar : "baz" }
      d = new EventedArray(1,2,o)
      expect(d.values).toEqual([1,2,{bar:'baz'}])
      expect(d.remove(o)).toEqual({bar:'baz'})
      expect(d.values).toEqual([1,2])

      # Same for Arrays
      expect(e.remove(['a'])).toEqual(false)
      arr = ['b']
      e.set(arr)
      expect(e.remove(arr)).toEqual(['b'])
      expect(e.values).toEqual([1,2,['a'],{foo:'bar'}])

    it 'should allow you to each()/forEach() over its values', ->
      e = new EventedArray(1,2,3,4,5)
      res = []
      e.each (i) ->
        res.push i + 1
      expect(res).toEqual([2,3,4,5,6])
      expect(e.values).toEqual([1,2,3,4,5])

    it 'should map() over values returning a new array', ->
      e = new EventedArray(1,2,3,4,5)
      d = e.map (i) -> i + 1
      expect(d).toEqual([2,3,4,5,6])
      expect(e.values).toEqual([1,2,3,4,5])

    it 'should reduce() values to a new value', ->
      e = new EventedArray(1,2,3,4,5)
      sum = e.reduce(
        (memo, num) -> memo + num
        0)
      square = e.reduce(
        (memo, num) -> memo * num
        2)
      expect(sum).toEqual(15)
      expect(square).toEqual(240)
      expect(e.values).toEqual([1,2,3,4,5])

    it 'should reduceRight() values to a new value', ->
      e = new EventedArray(1,2,3,4,5)
      sumr = e.reduceRight(
        (memo, num) -> memo + num
        0)
      expect(sumr).toEqual(15)
      expect(e.values).toEqual([1,2,3,4,5])

    it 'should filter() values', ->
      e = new EventedArray(false, true, true, false)
      expect(e.filter(_.identity)).toEqual([true, true])
      d = new EventedArray(1,2,3,4,5,6,7,8,9,10)
      expect(d.filter((i) -> i % 2)).toEqual([1,3,5,7,9])

    it 'should reject() values', ->
      e = new EventedArray(false, true, true, false)
      expect(e.reject(_.identity)).toEqual([false, false])
      d = new EventedArray(1,2,3,4,5,6,7,8,9,10)
      expect(d.reject((i) -> i % 2)).toEqual([2,4,6,8,10])

    it 'should return every() value that is true', ->
      e = new EventedArray(1,2,3,2,5,6,2,8)
      expect(e.every((i) -> i == 2)).toEqual(false)
      d = new EventedArray(2,4,6,8,10)
      expect(d.every((i) -> i % 2 == 0)).toEqual(true)

    it 'should return any() value that is true', ->
      e = new EventedArray(1,2,3,2,5,6,2,8)
      expect(e.any((i) -> i == 2)).toEqual(true)
      expect(e.any((i) -> i == 6)).toEqual(true)

    it 'should know if its contains() a value', ->
      e = new EventedArray(3,4,8,9,6,3)
      expect(e.contains(8)).toEqual(true)
      expect(e.contains('a')).toEqual(false)

    it 'should be able to shuffle() values', ->
      e = new EventedArray(1,2,3,4,5)
      expect(e.shuffle()).toNotEqual([1,2,3,4,5])

    it 'should return the first value with first()', ->
      e = new EventedArray(1,2,3,4,5)
      expect(e.first()).toEqual(1)
      expect(e.first(2)).toEqual([1,2])

    it 'should return the rest() of the values', ->
      e = new EventedArray(1,2,3,4,5)
      expect(e.rest()).toEqual([2,3,4,5])
      expect(e.rest(2)).toEqual([3,4,5])
      expect(e.rest(3)).toEqual([4,5])

    it 'should return the initial() values', ->
      e = new EventedArray(1,2,3,4,5)
      expect(e.initial()).toEqual([1,2,3,4])
      expect(e.initial(3)).toEqual([1,2])

    it 'should return the last() values', ->
      e = new EventedArray(1,2,3,4,5)
      expect(e.last()).toEqual(5)
      expect(e.last(2)).toEqual([4,5])

    it 'should return the index of an item', ->
      e = new EventedArray('a','b','c','d','e')
      expect(e.indexOf('b')).toEqual(1)
      expect(e.indexOf('e')).toEqual(4)


    # Events!
    describe 'EventedArray Events', ->

      catchFn = jasmine.createSpy 'catchFn'

      it 'can be registered', ->
        e = new EventedArray()
        e.register 'set', _.identity
        e.register 'get', _.identity
        expect(_.isObject(e.events)).toEqual(true)
        expect(_.keys(e.events)).toEqual(['set', 'get'])

      it 'can register and call set event', ->
        e = new EventedArray(1,2,3,4,5)
        e.register 'set', catchFn
        e.set 6
        expect(catchFn).toHaveBeenCalled()
        expect(catchFn).toHaveBeenCalledWith(6)
        catchFn.reset()

      it 'can register and call get event', ->
        e = new EventedArray(5,6,7,8,9)
        e.register 'get', catchFn
        e.get 2
        expect(catchFn).toHaveBeenCalled()
        expect(catchFn).toHaveBeenCalledWith(7)
        catchFn.reset()

        # If a get does not exist then the event is not called
        e.get 8
        expect(catchFn).not.toHaveBeenCalled()
        catchFn.reset()

      it 'can register and call remove event', ->
        e = new EventedArray('a',5,45)
        e.register 'remove', catchFn
        e.remove 'a'
        expect(catchFn).toHaveBeenCalled()
        expect(catchFn).toHaveBeenCalledWith('a')
