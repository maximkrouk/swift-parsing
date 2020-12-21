extension Parser {
  /// Returns a parser that transforms the output of this parser with a given closure.
  ///
  /// This method is similar to `Sequence.map`, `Optional.map`, and`Result.map` in the Swift
  /// standard library, as well as `Publisher.map` in the Combine framework.
  ///
  /// - Parameter transform: A closure that transforms values of this parser's output.
  /// - Returns: A parser of transformed outputs.
  @inlinable
  public func map<NewOutput>(
    _ transform: @escaping (Output) -> NewOutput
  ) -> Parsers.Map<Self, NewOutput> {
    .init(upstream: self, transform: transform)
  }
}

extension Parsers {
  /// A parser that transforms the output of another parser with a given closure.
  public struct Map<Upstream, Output>: Parser where Upstream: Parser {
    /// The parser from which this parser receives output.
    public let upstream: Upstream

    /// The closure that transforms output from the upstream parser.
    public let transform: (Upstream.Output) -> Output

    @inlinable
    public init(upstream: Upstream, transform: @escaping (Upstream.Output) -> Output) {
      self.upstream = upstream
      self.transform = transform
    }

    @inlinable
    @inline(__always)
    public func parse(_ input: inout Upstream.Input) -> Output? {
      self.upstream.parse(&input).map(self.transform)
    }
  }
}