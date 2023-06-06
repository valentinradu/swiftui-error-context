//
//  View+ErrorContext.swift
//
//
//  Created by Valentin Radu on 11/02/2023.
//

import AnyError
import SwiftUI

@MainActor
struct ErrorContextStorage {
    static let empty: ErrorContextStorage = .init()
    private var _errors: [AnyError] = []

    mutating func append(error: some Error) {
        _errors.append(error.asAnyError)
    }

    mutating func remove(error: some Error) {
        if let i = _errors.firstIndex(of: error.asAnyError) {
            _errors.remove(at: i)
        }
    }

    var allErrors: [AnyError] {
        _errors
    }
}

private struct ErrorContextStorageEnvironmentKey: EnvironmentKey {
    static var defaultValue: Binding<ErrorContextStorage> = .constant(.empty)
}

private extension EnvironmentValues {
    var errorContextStorage: Binding<ErrorContextStorage> {
        get { self[ErrorContextStorageEnvironmentKey.self] }
        set { self[ErrorContextStorageEnvironmentKey.self] = newValue }
    }
}

@MainActor
public struct ErrorContext {
    public static let empty: ErrorContext = .init(storage: .constant(.init()))
    @Binding private var _storage: ErrorContextStorage

    init(storage: Binding<ErrorContextStorage>) {
        __storage = storage
    }

    public func report(error: some Error) {
        _storage.append(error: error)
    }

    public func dismiss(error: some Error) {
        _storage.remove(error: error)
    }

    public func perform(_ action: () throws -> Void) {
        do {
            try action()
        } catch {
            _storage.append(error: error)
        }
    }

    public func lookUp<E>(error: E.Type) -> [E] where E: Error {
        _storage.allErrors.compactMap {
            $0.underlyingError as? E
        }
    }

    public var allErrors: [AnyError] {
        _storage.allErrors
    }
}

public struct ErrorContextProvider<C>: View where C: View {
    @State private var _storage: ErrorContextStorage = .empty
    private let _content: C

    public init(@ViewBuilder _ contentProvider: @escaping () -> C) {
        _content = contentProvider()
    }

    public var body: some View {
        _content
            .environment(\.errorContextStorage, $_storage)
    }
}

public struct ErrorContextReader<C>: View where C: View {
    public typealias ContentProvider = (ErrorContext) -> C
    private let _contentProvider: ContentProvider
    @Environment(\.errorContextStorage) private var _errorContextStorage

    public init(@ViewBuilder _ contentProvider: @escaping ContentProvider) {
        _contentProvider = contentProvider
    }

    public var body: some View {
        let errorContext = ErrorContext(storage: _errorContextStorage)
        _contentProvider(errorContext)
    }
}
