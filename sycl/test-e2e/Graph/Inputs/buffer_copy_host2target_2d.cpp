// Tests adding 2d buffer copy -- Host to Target (write path) --  nodes
// and submitting the graph.

#include "../graph_common.hpp"

int main() {
  queue Queue;

  using T = int;

  std::vector<T> DataA(Size * Size), DataB(Size * Size);
  std::iota(DataA.begin(), DataA.end(), 1);
  std::iota(DataB.begin(), DataB.end(), 1000);

  std::vector<T> ReferenceA(DataA);
  for (size_t i = 0; i < Size * Size; i++) {
    ReferenceA[i] = DataB[i];
  }

  exp_ext::command_graph Graph{Queue.get_context(), Queue.get_device()};

  // Make the buffers 2D so we can test the rect write path
  buffer BufferA{DataA.data(), range<2>(Size, Size)};
  BufferA.set_write_back(false);

  auto NodeA = add_node(Graph, Queue, [&](handler &CGH) {
    auto AccA = BufferA.get_access<access::mode::write>(CGH);
    CGH.copy(DataB.data(), AccA);
  });

  auto GraphExec = Graph.finalize();
  Queue.submit([&](handler &CGH) { CGH.ext_oneapi_graph(GraphExec); }).wait();

  host_accessor HostAccA(BufferA);

  for (size_t i = 0; i < Size; i++) {
    for (size_t j = 0; j < Size; j++) {
      assert(ReferenceA[i * Size + j] == HostAccA[i][j]);
    }
  }

  return 0;
}
